import 'store_profil.dart';

/// Data CONTOH untuk tampilan. Nanti diganti data asli dari database.
class DataContoh {
  DataContoh._();

  // Nama, jam bangun, dan target tidur kini diambil dari StoreProfil
  // (bisa diubah di halaman Profil).
  static String get namaDepan => StoreProfil.instance.namaDepan;
  static String get namaLengkap => StoreProfil.instance.nama;

  static const int skor = 82;
  static const int skorKemarin = 78;
  static const String durasiTidur = '7j 15m';
  static const String jamTidur = '23:00–06:15';

  static const String sleepDebt = '5j 30m';
  static const String sleepDebtKet = '7 hari terakhir';

  static const int konsistensi = 78;
  static const String konsistensiKet = 'Selisih jam tidur ±40 mnt';

  /// Sleep Score 7 hari terakhir, urutan dari yang terlama ke hari ini.
  static const List<int> skorMingguan = [79, 71, 77, 88, 80, 74, 82];

  static String get tidurIdeal {
    final p = StoreProfil.instance;
    return _jam(p.bangunMenit - p.targetJam * 60);
  }

  static String get bangunIdeal => _jam(StoreProfil.instance.bangunMenit);
  static int get targetJam => StoreProfil.instance.targetJam;

  static String _jam(int menit) {
    final m = ((menit % 1440) + 1440) % 1440;
    return '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
  }
  static const String pengingat = '22:00';

  /// Kenaikan skor rata-rata selama program (CONTOH, belum dihitung).
  static const int programNaikSkor = 6;

  static const int programHari = 5;
  static const int programTotal = 14;
  static const String programHariIni = 'rutinitas tenang sebelum tidur';

  static const String temuan =
      'Hari dengan kafein setelah 15:00 punya skor rata-rata 9 poin lebih rendah. Ini hubungan statistik dari catatanmu, bukan diagnosis.';
}
