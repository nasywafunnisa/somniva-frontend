import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'data_contoh.dart';
import 'entri_tidur.dart';
import 'format_tanggal.dart';
import 'laporan_tidur.dart';

const PdfColor _hijauTua = PdfColor.fromInt(0xFF56654D);
const PdfColor _hijauGelap = PdfColor.fromInt(0xFF2F3A2B);
const PdfColor _hijauPastel = PdfColor.fromInt(0xFFDCE3D4);
const PdfColor _krim = PdfColor.fromInt(0xFFF5F1E8);
const PdfColor _abu = PdfColor.fromInt(0xFF5F6858);

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

pw.Widget _judulBagian(String teks) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18, bottom: 8),
    child: pw.Text(
      _bersih(teks),
      style: pw.TextStyle(
        fontSize: 15,
        fontWeight: pw.FontWeight.bold,
        color: _hijauGelap,
      ),
    ),
  );
}

pw.Widget _angka(String nilai, String label) {
  return pw.Expanded(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          _bersih(nilai),
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: _hijauGelap,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(_bersih(label),
            style: const pw.TextStyle(fontSize: 10, color: _abu)),
      ],
    ),
  );
}

pw.Widget _sel(String teks, {bool tebal = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    child: pw.Text(
      _bersih(teks),
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: tebal ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: _hijauGelap,
      ),
    ),
  );
}

/// Membuat file PDF laporan dari data [l], hanya bagian yang dipilih di [isi].
Future<Uint8List> buatPdfLaporan(LaporanTidur l, IsiLaporan isi) async {
  final doc = pw.Document(
    title: 'Laporan Tidur Somniva',
    author: 'Somniva',
  );

  final widgets = <pw.Widget>[
    // Kepala laporan
    pw.Text(
      'Laporan Tidur',
      style: pw.TextStyle(
        fontSize: 26,
        fontWeight: pw.FontWeight.bold,
        color: _hijauGelap,
      ),
    ),
    pw.SizedBox(height: 4),
    pw.Text(
      _bersih('Somniva - ${l.periode(pemisah: '-')} (${l.malam.length} malam)'),
      style: const pw.TextStyle(fontSize: 12, color: _abu),
    ),
    pw.Text(
      _bersih(
          'Untuk: ${DataContoh.namaLengkap}   Dibuat: ${FormatTanggal.panjang(l.dibuat)}'),
      style: const pw.TextStyle(fontSize: 10, color: _abu),
    ),
    pw.SizedBox(height: 16),
    pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _hijauPastel,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        children: [
          _angka('${l.rataSkor}', 'Rata-rata skor'),
          _angka(l.rataDurasiTeks, 'Rata-rata tidur'),
          _angka(l.debtTeks, 'Sleep Debt'),
        ],
      ),
    ),
  ];

  if (isi.faktor) {
    widgets.add(_judulBagian('Sleep Score & faktor'));
    widgets.add(pw.Text(
      'Rata-rata nilai tiap faktor (0 sampai 100) selama periode ini.',
      style: const pw.TextStyle(fontSize: 10, color: _abu),
    ));
    widgets.add(pw.SizedBox(height: 8));
    for (final f in l.faktorRata) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 140,
              child: pw.Text(_bersih(f.nama),
                  style: const pw.TextStyle(fontSize: 11, color: _hijauGelap)),
            ),
            pw.Container(
              width: 240,
              height: 9,
              decoration: pw.BoxDecoration(
                color: _krim,
                borderRadius: pw.BorderRadius.circular(5),
              ),
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                width: 240 * (f.nilai.clamp(0, 100) / 100),
                height: 9,
                decoration: pw.BoxDecoration(
                  color: _hijauTua,
                  borderRadius: pw.BorderRadius.circular(5),
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text('${f.nilai}',
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: _hijauGelap)),
          ],
        ),
      ));
    }
  }

  if (isi.debt) {
    widgets.add(_judulBagian('Sleep Debt'));
    final target = DataContoh.targetJam;
    widgets.add(pw.Text(
      l.debtMenit == 0
          ? 'Tidak ada Sleep Debt pada periode ini. Total tidurmu sudah memenuhi target $target jam per malam.'
          : 'Sleep Debt periode ini ${l.debtTeks}, dihitung dari target $target jam per malam dikurangi total tidur. Tidur berlebih di satu malam ikut menutup kekurangan malam lain.',
      style:
          const pw.TextStyle(fontSize: 11, color: _hijauGelap, lineSpacing: 3),
    ));
  }

  if (isi.pola) {
    widgets.add(_judulBagian('Pola & korelasi'));
    for (final p in l.pola) {
      widgets.add(pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(_bersih(p.judul),
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: _hijauGelap)),
            pw.SizedBox(height: 2),
            pw.Text(_bersih(p.ringkasan),
                style: const pw.TextStyle(
                    fontSize: 10.5, color: _hijauGelap, lineSpacing: 2)),
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
          _sel(
              '${EntriTidur.formatJam(e.tidur)} - ${EntriTidur.formatJam(e.bangun)}'),
          _sel(e.durasiTeks),
          _sel('${m.skor}'),
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

  widgets.add(pw.SizedBox(height: 20));
  widgets.add(pw.Text(
    'Ringkasan edukatif dari catatanmu, bukan diagnosis atau hasil pemeriksaan medis. '
    'Catatan sebelum hari ini masih data contoh sampai jurnalmu terisi tiap hari.',
    style: const pw.TextStyle(fontSize: 9.5, color: _abu, lineSpacing: 2),
  ));

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 44),
      footer: (ctx) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Somniva - halaman ${ctx.pageNumber} dari ${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: _abu),
        ),
      ),
      build: (ctx) => widgets,
    ),
  );

  return doc.save();
}
