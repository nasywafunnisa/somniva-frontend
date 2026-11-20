import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'data_contoh.dart';
import 'entri_tidur.dart';
import 'format_tanggal.dart';
import 'laporan_tidur.dart';
import 'riwayat_tidur.dart';

const PdfColor _hijauTua = PdfColor.fromInt(0xFF56654D);
const PdfColor _hijauSedang = PdfColor.fromInt(0xFF74836A);
const PdfColor _hijauGelap = PdfColor.fromInt(0xFF2F3A2B);
const PdfColor _hijauPastel = PdfColor.fromInt(0xFFDCE3D4);
const PdfColor _hijauMuda = PdfColor.fromInt(0xFFE7ECE0);
const PdfColor _krim = PdfColor.fromInt(0xFFF5F1E8);
const PdfColor _abu = PdfColor.fromInt(0xFF5F6858);
const PdfColor _cokelat = PdfColor.fromInt(0xFFA9805A);
const PdfColor _putih = PdfColor.fromInt(0xFFFFFFFF);

/// Font bawaan PDF (Helvetica) hanya mengenal huruf Latin-1. Tanda baca
/// seperti en dash diganti, karakter lain di luar Latin-1 dibuang.
String _bersih(String s) {
  final ganti = s
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('→', '->')
      .replaceAll('±', '+/-')
      .replaceAll('’', "'")
      .replaceAll('“', '"')
      .replaceAll('”', '"');
  final b = StringBuffer();
  for (final r in ganti.runes) {
    if (r <= 255) b.writeCharCode(r);
  }
  return b.toString();
}

// =============================================================================
// Perhitungan insight (semua dari data laporan, tidak ada angka karangan)
// =============================================================================

PdfColor _warnaSkor(int s) =>
    s >= 80 ? _hijauTua : (s >= 65 ? _hijauSedang : _cokelat);

String _jam(int menit) {
  final m = menit % 1440;
  final h = (m ~/ 60).toString().padLeft(2, '0');
  final mm = (m % 60).toString().padLeft(2, '0');
  return '$h:$mm';
}

/// Menit sejak 00:00; tidur setelah tengah malam dihitung 24:00 dan seterusnya.
int _menitTidur(MalamRiwayat m) {
  final t = m.entri.tidur;
  final v = t.hour * 60 + t.minute;
  return t.hour < 12 ? v + 1440 : v;
}

class _Insight {
  final String judul;
  final String isi;
  const _Insight(this.judul, this.isi);
}

FaktorSkor _terkuat(LaporanTidur l) =>
    l.faktorRata.reduce((a, b) => b.nilai > a.nilai ? b : a);

FaktorSkor _terlemah(LaporanTidur l) =>
    l.faktorRata.reduce((a, b) => b.nilai < a.nilai ? b : a);

int _debtPerMalam(LaporanTidur l) =>
    l.malam.isEmpty ? 0 : (l.debtMenit / l.malam.length).round();

List<_Insight> _insight(LaporanTidur l) {
  final hasil = <_Insight>[];
  final n = l.malam.length;

  // 1. Jam mulai tidur vs skor.
  if (n >= 4) {
    final menit = [for (final m in l.malam) _menitTidur(m)];
    final rata = menit.reduce((a, b) => a + b) / n;
    final awal = <int>[];
    final larut = <int>[];
    final menitAwal = <int>[];
    final menitLarut = <int>[];
    for (var i = 0; i < n; i++) {
      if (menit[i] < rata) {
        awal.add(l.malam[i].skor);
        menitAwal.add(menit[i]);
      } else {
        larut.add(l.malam[i].skor);
        menitLarut.add(menit[i]);
      }
    }
    if (awal.isNotEmpty && larut.isNotEmpty) {
      int avg(List<int> x) => (x.reduce((a, b) => a + b) / x.length).round();
      final sa = avg(awal);
      final sl = avg(larut);
      final diff = sa - sl;
      if (diff >= 3) {
        hasil.add(_Insight(
          'Tidur lebih awal berhubungan dengan skor lebih tinggi',
          'Pada ${awal.length} malam dengan jam tidur lebih awal (rata-rata ${_jam(avg(menitAwal))}) skor rata-ratanya $sa, '
              'dibanding $sl pada ${larut.length} malam yang lebih larut (rata-rata ${_jam(avg(menitLarut))}). Selisih $diff poin.',
        ));
      } else if (diff <= -3) {
        hasil.add(const _Insight(
          'Jam tidur dan skor',
          'Di catatanmu, tidur lebih awal belum terlihat meningkatkan skor.',
        ));
      }
    }

    // 2. Konsistensi jam tidur.
    final selisih =
        menit.reduce((a, b) => a > b ? a : b) - menit.reduce((a, b) => a < b ? a : b);
    if (selisih >= 30) {
      hasil.add(_Insight(
        'Jam mulai tidur belum konsisten',
        'Jam mulai tidurmu bergeser hingga $selisih menit antar malam (dari ${_jam(menit.reduce((a, b) => a < b ? a : b))} sampai ${_jam(menit.reduce((a, b) => a > b ? a : b))}). Jadwal yang lebih tetap membantu skor konsistensi.',
      ));
    } else {
      hasil.add(_Insight(
        'Jam mulai tidur cukup konsisten',
        'Selisih jam mulai tidur antar malam hanya $selisih menit. Pertahankan pola ini.',
      ));
    }
  }

  // 3. Malam terbaik dan terendah.
  if (n >= 2) {
    var terbaik = l.malam.first;
    var terendah = l.malam.first;
    for (final m in l.malam) {
      if (m.skor > terbaik.skor) terbaik = m;
      if (m.skor < terendah.skor) terendah = m;
    }
    hasil.add(_Insight(
      'Malam terbaik dan terendah',
      'Terbaik: ${FormatTanggal.ringkas(terbaik.tanggal)} (skor ${terbaik.skor}, tidur ${terbaik.entri.durasiTeks}). '
          'Terendah: ${FormatTanggal.ringkas(terendah.tanggal)} (skor ${terendah.skor}, tidur ${terendah.entri.durasiTeks}).',
    ));
  }

  // 4. Hubungan dari jurnal (kafein, layar, aktivitas). Yang datanya belum
  // cukup ditaruh paling akhir dan ditulis apa adanya.
  final cukup = <_Insight>[];
  final belum = <_Insight>[];
  for (final p in l.pola) {
    final i = _Insight(p.judul, p.ringkasan);
    if (p.ringkasan.startsWith('Belum cukup')) {
      belum.add(i);
    } else {
      cukup.add(i);
    }
  }
  hasil.addAll(cukup);
  hasil.addAll(belum);
  return hasil;
}

List<String> _rekomendasi(LaporanTidur l) {
  final urut = [...l.faktorRata]..sort((a, b) => a.nilai.compareTo(b.nilai));
  final target = DataContoh.targetJam;
  final hasil = <String>[];

  String untuk(FaktorSkor f) {
    final n = f.nama.toLowerCase();
    if (n.contains('waktu mulai')) {
      return 'Waktu mulai tidur (nilai ${f.nilai}): usahakan mulai tidur di jam yang sama setiap malam, dan majukan secara bertahap 15 menit.';
    }
    if (n.contains('konsistensi')) {
      return 'Konsistensi jadwal (nilai ${f.nilai}): jaga jam tidur dan jam bangun tetap, termasuk di akhir pekan, dengan selisih tidak lebih dari 30 menit.';
    }
    if (n.contains('kafein')) {
      return 'Kafein (nilai ${f.nilai}): batasi kopi atau teh pekat setelah pukul 15:00.';
    }
    if (n.contains('gadget') || n.contains('layar')) {
      return 'Gadget sebelum tidur (nilai ${f.nilai}): kurangi layar 30 sampai 60 menit sebelum tidur.';
    }
    if (n.contains('stres')) {
      return 'Tingkat stres (nilai ${f.nilai}): coba latihan relaksasi atau pernapasan 5 sampai 10 menit sebelum tidur.';
    }
    if (n.contains('durasi')) {
      return 'Durasi tidur (nilai ${f.nilai}): majukan jam tidur supaya total tidur mendekati target $target jam per malam.';
    }
    return '${f.nama} (nilai ${f.nilai}): faktor ini paling rendah, mulai perbaiki dari sini.';
  }

  for (final f in urut.take(2)) {
    hasil.add(untuk(f));
  }
  if (l.debtMenit > 0) {
    hasil.add(
        'Sleep Debt ${l.debtTeks}: cicil bertahap dengan menambah 15 sampai 30 menit tidur per malam, bukan tidur panjang sekali waktu.');
  }
  return hasil;
}

String _ringkasan(LaporanTidur l) {
  final target = DataContoh.targetJam;
  final kuat = _terkuat(l);
  final lemah = _terlemah(l);
  final b = StringBuffer();
  b.write(
      'Selama ${l.malam.length} malam, rata-rata Sleep Score kamu ${l.rataSkor} (${FormatTanggal.labelSkor(l.rataSkor)}) '
      'dengan rata-rata tidur ${l.rataDurasiTeks} per malam, dari target $target jam. ');
  if (l.debtMenit > 0) {
    b.write(
        'Sleep Debt ${l.debtTeks}, setara sekitar ${_debtPerMalam(l)} menit kurang tidur per malam. ');
  } else {
    b.write('Total tidurmu sudah memenuhi target. ');
  }
  b.write(
      'Faktor terkuat adalah ${kuat.nama.toLowerCase()} (${kuat.nilai}), '
      'sedangkan yang paling perlu perhatian adalah ${lemah.nama.toLowerCase()} (${lemah.nilai}).');
  return b.toString();
}

// =============================================================================
// Komponen tampilan
// =============================================================================

pw.Widget _judulBagian(String teks) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 20, bottom: 10),
    child: pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 15,
          decoration: pw.BoxDecoration(
            color: _hijauTua,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          _bersih(teks),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: _hijauGelap,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _chip(String teks, PdfColor latar, PdfColor warnaTeks) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: pw.BoxDecoration(
      color: latar,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Text(
      _bersih(teks),
      style: pw.TextStyle(
        fontSize: 8.5,
        fontWeight: pw.FontWeight.bold,
        color: warnaTeks,
      ),
    ),
  );
}

pw.Widget _kartuAngka({
  required String nilai,
  required String label,
  required String status,
  required PdfColor warnaStatus,
  required String catatan,
}) {
  return pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _putih,
        border: pw.Border.all(color: _hijauPastel, width: 1),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(_bersih(label),
              style: const pw.TextStyle(fontSize: 9.5, color: _abu)),
          pw.SizedBox(height: 4),
          pw.Text(
            _bersih(nilai),
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: _hijauGelap,
            ),
          ),
          pw.SizedBox(height: 6),
          _chip(status, _hijauMuda, warnaStatus),
          pw.SizedBox(height: 6),
          pw.Text(_bersih(catatan),
              style: const pw.TextStyle(
                  fontSize: 9, color: _abu, lineSpacing: 1.5)),
        ],
      ),
    ),
  );
}

pw.Widget _sel(String teks,
    {bool tebal = false, PdfColor warna = _hijauGelap}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    child: pw.Text(
      _bersih(teks),
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: tebal ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: warna,
      ),
    ),
  );
}

/// Grafik batang skor per malam (tanpa gambar, hanya kotak).
pw.Widget _grafikTren(LaporanTidur l) {
  const tinggiMaks = 70.0;
  final tampilLabel = l.malam.length <= 14;
  final bars = <pw.Widget>[];
  for (var i = 0; i < l.malam.length; i++) {
    final m = l.malam[i];
    final t = ((m.skor.clamp(40, 100) - 40) / 60) * tinggiMaks;
    if (i > 0) bars.add(pw.SizedBox(width: l.malam.length > 14 ? 2 : 8));
    bars.add(
      pw.Expanded(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            if (tampilLabel)
              pw.Text('${m.skor}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _hijauGelap)),
            if (tampilLabel) pw.SizedBox(height: 3),
            pw.Container(
              height: t < 4 ? 4 : t,
              decoration: pw.BoxDecoration(
                color: _warnaSkor(m.skor),
                borderRadius: pw.BorderRadius.circular(3),
              ),
            ),
            if (tampilLabel) pw.SizedBox(height: 4),
            if (tampilLabel)
              pw.Text(
                _bersih(FormatTanggal.hariPendek(m.tanggal)),
                style: const pw.TextStyle(fontSize: 8.5, color: _abu),
              ),
          ],
        ),
      ),
    );
  }

  return pw.Container(
    padding: const pw.EdgeInsets.fromLTRB(16, 14, 16, 12),
    decoration: pw.BoxDecoration(
      color: _putih,
      border: pw.Border.all(color: _hijauPastel, width: 1),
      borderRadius: pw.BorderRadius.circular(12),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: tinggiMaks + 36,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: bars,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            _legenda(_hijauTua, 'Baik (80 ke atas)'),
            pw.SizedBox(width: 14),
            _legenda(_hijauSedang, 'Cukup (65-79)'),
            pw.SizedBox(width: 14),
            _legenda(_cokelat, 'Perlu perhatian (di bawah 65)'),
          ],
        ),
      ],
    ),
  );
}

pw.Widget _legenda(PdfColor warna, String teks) {
  return pw.Row(
    children: [
      pw.Container(
        width: 8,
        height: 8,
        decoration: pw.BoxDecoration(
          color: warna,
          borderRadius: pw.BorderRadius.circular(2),
        ),
      ),
      pw.SizedBox(width: 4),
      pw.Text(_bersih(teks),
          style: const pw.TextStyle(fontSize: 8.5, color: _abu)),
    ],
  );
}

/// Membuat file PDF laporan dari data [l], hanya bagian yang dipilih di [isi].
Future<Uint8List> buatPdfLaporan(LaporanTidur l, IsiLaporan isi) async {
  final doc = pw.Document(
    title: 'Laporan Tidur Somniva',
    author: 'Somniva',
  );

  final target = DataContoh.targetJam;
  final kurangPerMalam = target * 60 - l.rataDurasiMenit;
  final debtMalam = _debtPerMalam(l);
  int tertinggi = 0, terendah = 100;
  for (final m in l.malam) {
    if (m.skor > tertinggi) tertinggi = m.skor;
    if (m.skor < terendah) terendah = m.skor;
  }

  final widgets = <pw.Widget>[
    // ---- Kepala laporan ----
    pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: pw.BoxDecoration(
        color: _hijauTua,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'SOMNIVA',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 2,
                    color: _hijauPastel,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Laporan Tidur',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: _putih,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  _bersih('${l.periode(pemisah: '-')}  (${l.malam.length} malam)'),
                  style: const pw.TextStyle(fontSize: 11.5, color: _hijauPastel),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Untuk',
                  style: const pw.TextStyle(fontSize: 8.5, color: _hijauPastel)),
              pw.Text(
                _bersih(DataContoh.namaLengkap),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _putih,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text('Dibuat',
                  style: const pw.TextStyle(fontSize: 8.5, color: _hijauPastel)),
              pw.Text(
                _bersih(FormatTanggal.panjang(l.dibuat)),
                style: const pw.TextStyle(fontSize: 10, color: _putih),
              ),
            ],
          ),
        ],
      ),
    ),
    pw.SizedBox(height: 14),

    // ---- Ringkasan ----
    pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _krim,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Ringkasan',
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: _hijauGelap)),
          pw.SizedBox(height: 6),
          pw.Text(
            _bersih(_ringkasan(l)),
            style: const pw.TextStyle(
                fontSize: 10.5, color: _hijauGelap, lineSpacing: 3),
          ),
        ],
      ),
    ),
    pw.SizedBox(height: 14),

    // ---- Tiga kartu angka ----
    pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _kartuAngka(
          nilai: '${l.rataSkor}',
          label: 'Rata-rata Sleep Score',
          status: FormatTanggal.labelSkor(l.rataSkor),
          warnaStatus: _warnaSkor(l.rataSkor),
          catatan: 'Tertinggi $tertinggi, terendah $terendah.',
        ),
        pw.SizedBox(width: 10),
        _kartuAngka(
          nilai: l.rataDurasiTeks,
          label: 'Rata-rata durasi tidur',
          status: kurangPerMalam <= 0 ? 'Sesuai target' : 'Di bawah target',
          warnaStatus: kurangPerMalam <= 0 ? _hijauTua : _cokelat,
          catatan: kurangPerMalam <= 0
              ? 'Target $target jam per malam tercapai.'
              : 'Target $target jam, kurang sekitar $kurangPerMalam menit per malam.',
        ),
        pw.SizedBox(width: 10),
        _kartuAngka(
          nilai: l.debtTeks,
          label: 'Sleep Debt',
          status: l.debtMenit == 0
              ? 'Tidak ada'
              : (debtMalam <= 30 ? 'Ringan' : 'Perlu dicicil'),
          warnaStatus: l.debtMenit == 0 || debtMalam <= 30 ? _hijauTua : _cokelat,
          catatan: l.debtMenit == 0
              ? 'Total tidur memenuhi target.'
              : 'Setara sekitar $debtMalam menit kurang per malam.',
        ),
      ],
    ),

    // ---- Tren ----
    _judulBagian('Tren Sleep Score'),
    _grafikTren(l),
  ];

  if (isi.faktor) {
    widgets.add(_judulBagian('Sleep Score & faktor'));
    widgets.add(pw.Text(
      'Rata-rata nilai tiap faktor (0 sampai 100) selama periode ini. Faktor terkuat dan terlemah ditandai.',
      style: const pw.TextStyle(fontSize: 10, color: _abu),
    ));
    widgets.add(pw.SizedBox(height: 10));
    final kuat = _terkuat(l);
    final lemah = _terlemah(l);
    final urut = [...l.faktorRata]..sort((a, b) => b.nilai.compareTo(a.nilai));
    for (final f in urut) {
      final warna = _warnaSkor(f.nilai);
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 130,
              child: pw.Text(_bersih(f.nama),
                  style: const pw.TextStyle(fontSize: 10.5, color: _hijauGelap)),
            ),
            pw.Container(
              width: 220,
              height: 9,
              decoration: pw.BoxDecoration(
                color: _krim,
                borderRadius: pw.BorderRadius.circular(5),
              ),
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 220 * (f.nilai.clamp(0, 100) / 100),
                height: 9,
                decoration: pw.BoxDecoration(
                  color: warna,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.SizedBox(
              width: 22,
              child: pw.Text('${f.nilai}',
                  style: pw.TextStyle(
                      fontSize: 10.5,
                      fontWeight: pw.FontWeight.bold,
                      color: _hijauGelap)),
            ),
            if (identical(f, kuat))
              _chip('Terkuat', _hijauMuda, _hijauTua)
            else if (identical(f, lemah))
              _chip('Perlu perhatian', _krim, _cokelat),
          ],
        ),
      ));
    }
  }

  if (isi.debt) {
    widgets.add(_judulBagian('Sleep Debt'));
    widgets.add(pw.Text(
      l.debtMenit == 0
          ? 'Tidak ada Sleep Debt pada periode ini. Total tidurmu sudah memenuhi target $target jam per malam.'
          : 'Sleep Debt periode ini ${l.debtTeks}, dihitung dari target $target jam per malam dikurangi total tidur '
              '(setara sekitar $debtMalam menit per malam). Tidur berlebih di satu malam ikut menutup kekurangan malam lain.',
      style: const pw.TextStyle(fontSize: 10.5, color: _hijauGelap, lineSpacing: 3),
    ));
  }

  if (isi.pola) {
    widgets.add(_judulBagian('Insight dari catatanmu'));
    for (final p in _insight(l)) {
      widgets.add(pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(bottom: 8),
        padding: const pw.EdgeInsets.fromLTRB(12, 9, 12, 9),
        decoration: pw.BoxDecoration(
          color: _hijauMuda,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(_bersih(p.judul),
                style: pw.TextStyle(
                    fontSize: 10.5,
                    fontWeight: pw.FontWeight.bold,
                    color: _hijauGelap)),
            pw.SizedBox(height: 3),
            pw.Text(_bersih(p.isi),
                style: const pw.TextStyle(
                    fontSize: 10, color: _hijauGelap, lineSpacing: 2)),
          ],
        ),
      ));
    }
  }

  // ---- Rekomendasi ----
  final rek = _rekomendasi(l);
  if (rek.isNotEmpty) {
    widgets.add(_judulBagian('Rekomendasi'));
    for (var i = 0; i < rek.length; i++) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 18,
              height: 18,
              alignment: pw.Alignment.center,
              decoration: const pw.BoxDecoration(
                color: _hijauTua,
                shape: pw.BoxShape.circle,
              ),
              child: pw.Text('${i + 1}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _putih)),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text(_bersih(rek[i]),
                    style: const pw.TextStyle(
                        fontSize: 10.5, color: _hijauGelap, lineSpacing: 2.5)),
              ),
            ),
          ],
        ),
      ));
    }
  }

  if (isi.riwayat) {
    widgets.add(_judulBagian('Riwayat per malam'));
    final baris = <pw.TableRow>[
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: _hijauPastel),
        children: [
          _sel('Tanggal', tebal: true),
          _sel('Tidur - bangun', tebal: true),
          _sel('Durasi', tebal: true),
          _sel('Skor', tebal: true),
        ],
      ),
    ];
    for (final m in l.malam.reversed) {
      final e = m.entri;
      baris.add(pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _krim, width: 1)),
        ),
        children: [
          _sel(FormatTanggal.ringkas(m.tanggal)),
          _sel('${EntriTidur.formatJam(e.tidur)} - ${EntriTidur.formatJam(e.bangun)}'),
          _sel(e.durasiTeks),
          _sel('${m.skor}', tebal: true, warna: _warnaSkor(m.skor)),
        ],
      ));
    }
    widgets.add(pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(2.2),
        1: pw.FlexColumnWidth(2.2),
        2: pw.FlexColumnWidth(1.4),
        3: pw.FlexColumnWidth(1),
      },
      children: baris,
    ));
  }

  widgets.add(pw.SizedBox(height: 18));
  widgets.add(pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _krim,
      borderRadius: pw.BorderRadius.circular(10),
    ),
    child: pw.Text(
      'Catatan: laporan ini adalah ringkasan edukatif dari catatanmu, bukan diagnosis atau hasil pemeriksaan medis. '
      'Insight menunjukkan hubungan statistik, bukan sebab-akibat. '
      'Catatan sebelum hari ini masih data contoh sampai jurnalmu terisi tiap hari.',
      style: const pw.TextStyle(fontSize: 9, color: _abu, lineSpacing: 2),
    ),
  ));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 44),
      footer: (ctx) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Somniva - Laporan Tidur',
              style: const pw.TextStyle(fontSize: 9, color: _abu)),
          pw.Text(
            'Halaman ${ctx.pageNumber} dari ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: _abu),
          ),
        ],
      ),
      build: (ctx) => widgets,
    ),
  );

  return doc.save();
}
