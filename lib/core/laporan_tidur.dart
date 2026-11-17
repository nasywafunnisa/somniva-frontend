import 'data_contoh.dart';
import 'entri_tidur.dart';
import 'korelasi.dart';
import 'riwayat_tidur.dart';
import 'store_tidur.dart';

/// Pilihan rentang laporan: 7 hari, 30 hari, atau bulan ini.
enum RentangLaporan { tujuhHari, tigaPuluhHari, bulanIni }

extension RentangLaporanTeks on RentangLaporan {
  String get label {
    switch (this) {
      case RentangLaporan.tujuhHari:
        return '7 hari';
      case RentangLaporan.tigaPuluhHari:
        return '30 hari';
      case RentangLaporan.bulanIni:
        return 'Bulan ini';
    }
  }

  /// Jumlah malam yang masuk laporan.
  int get jumlahHari {
    switch (this) {
      case RentangLaporan.tujuhHari:
        return 7;
      case RentangLaporan.tigaPuluhHari:
        return 30;
      case RentangLaporan.bulanIni:
        return DateTime.now().day; // tanggal 1 sampai hari ini
    }
  }
}

/// Bagian mana saja yang ikut masuk ke PDF (kotak centang "Isi laporan").
class IsiLaporan {
  final bool faktor;
  final bool debt;
  final bool pola;
  final bool riwayat;

  const IsiLaporan({
    this.faktor = true,
    this.debt = true,
    this.pola = true,
    this.riwayat = true,
  });

  IsiLaporan ubah({bool? faktor, bool? debt, bool? pola, bool? riwayat}) {
    return IsiLaporan(
      faktor: faktor ?? this.faktor,
      debt: debt ?? this.debt,
      pola: pola ?? this.pola,
      riwayat: riwayat ?? this.riwayat,
    );
  }

  bool get kosong => !faktor && !debt && !pola && !riwayat;

  /// Nama bagian yang dipilih, untuk teks ringkasan.
  List<String> get daftarNama => [
        if (faktor) 'Sleep Score & faktor',
        if (debt) 'Sleep Debt',
        if (pola) 'Pola & korelasi',
        if (riwayat) 'Riwayat per malam',
      ];
}

/// Satu baris hasil pola untuk laporan.
class BarisPola {
  final String judul;
  final String ringkasan;
  const BarisPola(this.judul, this.ringkasan);
}

/// Semua angka yang dipakai di tampilan ringkasan dan di file PDF.
/// Sumbernya sama dengan halaman Grafik & Riwayat (StoreTidur + data contoh).
class LaporanTidur {
  final RentangLaporan rentang;
  final DateTime dibuat;
  final List<MalamRiwayat> malam; // terlama -> hari ini
  final int rataSkor;
  final int rataDurasiMenit;
  final int debtMenit;
  final List<FaktorSkor> faktorRata;
  final List<BarisPola> pola;

  const LaporanTidur._({
    required this.rentang,
    required this.dibuat,
    required this.malam,
    required this.rataSkor,
    required this.rataDurasiMenit,
    required this.debtMenit,
    required this.faktorRata,
    required this.pola,
  });

  static const List<String> _bulanPendek = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul',
    'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  static LaporanTidur buat(RentangLaporan rentang) {
    final sekarang = DateTime.now();
    final data = RiwayatTidur.ambil(rentang.jumlahHari);
    final entri = [for (final m in data) m.entri];

    // Rata-rata tiap faktor skor.
    final jumlahFaktor = HitungSkor.faktor(entri.first).length;
    final total = List<int>.filled(jumlahFaktor, 0);
    final nama = <String>[];
    for (final e in entri) {
      final f = HitungSkor.faktor(e, targetJam: DataContoh.targetJam);
      for (var i = 0; i < f.length; i++) {
        total[i] += f[i].nilai;
        if (nama.length < f.length) nama.add(f[i].nama);
      }
    }
    final faktorRata = [
      for (var i = 0; i < jumlahFaktor; i++)
        FaktorSkor(nama[i], (total[i] / entri.length).round()),
    ];

    // Sleep Debt. Untuk 7 hari memakai angka yang sama dengan halaman
    // Score & Debt. Rentang lain: target x jumlah malam dikurangi total tidur.
    int debt;
    if (rentang == RentangLaporan.tujuhHari) {
      debt = StoreTidur.instance.sleepDebtMenit;
    } else {
      final target = DataContoh.targetJam * 60 * data.length;
      var jumlah = 0;
      for (final m in data) {
        jumlah += m.durasiMenit;
      }
      debt = target - jumlah;
      if (debt < 0) debt = 0;
    }

    final kafein = Korelasi.kafein(entri);
    final layar = Korelasi.layar(entri);
    final aktivitas = Korelasi.aktivitas(entri);

    return LaporanTidur._(
      rentang: rentang,
      dibuat: sekarang,
      malam: data,
      rataSkor: RiwayatTidur.rataSkor(data),
      rataDurasiMenit: RiwayatTidur.rataDurasiMenit(data),
      debtMenit: debt,
      faktorRata: faktorRata,
      pola: [
        BarisPola('Kafein sore', kafein.ringkasan),
        BarisPola('Layar sebelum tidur', layar.ringkasan),
        BarisPola('Aktivitas fisik', aktivitas.ringkasan),
      ],
    );
  }

  String get rataDurasiTeks => EntriTidur.formatDurasi(rataDurasiMenit);
  String get debtTeks =>
      debtMenit == 0 ? '0m' : EntriTidur.formatDurasi(debtMenit);

  /// Contoh: "4-10 Nov 2026". [pemisah] di layar memakai en dash,
  /// di PDF memakai tanda hubung biasa.
  String periode({String pemisah = '–'}) {
    final a = malam.first.tanggal;
    final b = malam.last.tanggal;
    final bln = _bulanPendek[b.month - 1];
    if (a.month == b.month && a.year == b.year) {
      if (a.day == b.day) return '${b.day} $bln ${b.year}';
      return '${a.day}$pemisah${b.day} $bln ${b.year}';
    }
    return '${a.day} ${_bulanPendek[a.month - 1]} ${a.year} $pemisah '
        '${b.day} $bln ${b.year}';
  }

  String get namaFile {
    final b = malam.last.tanggal;
    final bulan = b.month.toString().padLeft(2, '0');
    final hari = b.day.toString().padLeft(2, '0');
    return 'laporan-tidur-somniva-${b.year}$bulan$hari.pdf';
  }
}
