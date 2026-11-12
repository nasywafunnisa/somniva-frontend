/// Data CONTOH untuk tampilan. Nanti diganti data asli dari database.
class DataContoh {
  DataContoh._();

  static const String namaDepan = 'Sari';
  static const String namaLengkap = 'Sari Wulandari';

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

  static const String tidurIdeal = '22:30';
  static const String bangunIdeal = '06:30';
  static const int targetJam = 8;
  static const String pengingat = '22:00';

  static const int programHari = 5;
  static const int programTotal = 14;
  static const String programHariIni = 'rutinitas tenang sebelum tidur';

  static const String temuan =
      'Hari dengan kafein setelah 15:00 punya skor rata-rata 9 poin lebih rendah. Ini hubungan statistik dari catatanmu, bukan diagnosis.';
}
