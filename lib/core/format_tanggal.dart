/// Format tanggal dan sapaan dalam bahasa Indonesia (tanpa paket tambahan).
class FormatTanggal {
  FormatTanggal._();

  static const List<String> _hari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  static const List<String> _hariPendek = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];
  static const List<String> _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  /// Contoh: "Kamis, 12 November 2026"
  static String panjang(DateTime d, {bool tahun = true}) {
    final dasar = '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]}';
    return tahun ? '$dasar ${d.year}' : dasar;
  }

  /// Contoh: "Kam"
  static String hariPendek(DateTime d) => _hariPendek[d.weekday - 1];

  /// Label 7 hari terakhir, yang terlama dulu, hari ini terakhir.
  static List<String> tujuhHariTerakhir(DateTime sekarang) {
    return List.generate(7, (i) {
      final d = sekarang.subtract(Duration(days: 6 - i));
      return hariPendek(d);
    });
  }

  static String salam(DateTime d) {
    final j = d.hour;
    if (j >= 4 && j < 11) return 'Selamat pagi';
    if (j >= 11 && j < 15) return 'Selamat siang';
    if (j >= 15 && j < 18) return 'Selamat sore';
    return 'Selamat malam';
  }

  /// Nama penilaian skor tidur.
  static String labelSkor(int skor) {
    if (skor >= 90) return 'Sangat baik';
    if (skor >= 80) return 'Baik';
    if (skor >= 65) return 'Cukup';
    return 'Perlu perhatian';
  }
}
