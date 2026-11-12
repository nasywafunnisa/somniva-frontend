import 'package:flutter/material.dart';

/// Satu catatan jurnal tidur (isi formulir Jurnal Tidur).
class EntriTidur {
  final TimeOfDay tidur;
  final TimeOfDay bangun;
  final String suasana; // Cemas, Biasa, Tenang, Semangat
  final int stres; // 1 sampai 5
  final int kafein; // jumlah cangkir
  final TimeOfDay kafeinTerakhir;
  final bool aktif; // ada aktivitas fisik hari ini
  final int gadgetMenit; // lama layar sebelum tidur

  const EntriTidur({
    required this.tidur,
    required this.bangun,
    required this.suasana,
    required this.stres,
    required this.kafein,
    required this.kafeinTerakhir,
    required this.aktif,
    required this.gadgetMenit,
  });

  EntriTidur salin({
    TimeOfDay? tidur,
    TimeOfDay? bangun,
    String? suasana,
    int? stres,
    int? kafein,
    TimeOfDay? kafeinTerakhir,
    bool? aktif,
    int? gadgetMenit,
  }) {
    return EntriTidur(
      tidur: tidur ?? this.tidur,
      bangun: bangun ?? this.bangun,
      suasana: suasana ?? this.suasana,
      stres: stres ?? this.stres,
      kafein: kafein ?? this.kafein,
      kafeinTerakhir: kafeinTerakhir ?? this.kafeinTerakhir,
      aktif: aktif ?? this.aktif,
      gadgetMenit: gadgetMenit ?? this.gadgetMenit,
    );
  }

  /// Lama tidur dalam menit. Kalau jam bangun lebih awal dari jam tidur,
  /// dianggap melewati tengah malam.
  int get durasiMenit {
    final t = tidur.hour * 60 + tidur.minute;
    final b = bangun.hour * 60 + bangun.minute;
    var d = b - t;
    if (d <= 0) d += 24 * 60;
    return d;
  }

  String get durasiTeks => formatDurasi(durasiMenit);
  String get rentangTeks => '${formatJam(tidur)}–${formatJam(bangun)}';

  static String formatJam(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Contoh: 435 -> "7j 15m", 120 -> "2j", 40 -> "40m"
  static String formatDurasi(int menit) {
    final h = menit ~/ 60;
    final m = menit % 60;
    if (h > 0 && m > 0) return '${h}j ${m}m';
    if (h > 0) return '${h}j';
    return '${m}m';
  }
}

class FaktorSkor {
  final String nama;
  final int nilai;
  const FaktorSkor(this.nama, this.nilai);
}

/// Penghitung Sleep Score dari satu catatan jurnal.
///
/// Setiap faktor bernilai 0 sampai 100, lalu digabung dengan bobot.
/// Aturan dan bobot di bawah ini RANCANGAN KITA SENDIRI untuk aplikasi
/// edukatif, bukan standar medis.
class HitungSkor {
  HitungSkor._();

  static int _batas(double v) => v.clamp(0, 100).round();

  static List<FaktorSkor> faktor(
    EntriTidur e, {
    int targetJam = 8,
    int selisihJadwalMenit = 40,
  }) {
    // 1. Durasi: makin dekat dengan target, makin tinggi.
    final durasi = 100 - (e.durasiMenit - targetJam * 60).abs() * 0.3;

    // 2. Konsistensi: makin kecil selisih jam tidur antar hari, makin tinggi.
    final konsistensi = 100 - selisihJadwalMenit * 0.55;

    // 3. Waktu mulai tidur: makin dekat 22:30, makin tinggi.
    var mulai = e.tidur.hour * 60 + e.tidur.minute;
    if (mulai < 12 * 60) mulai += 24 * 60; // 00:30 dihitung 24:30
    final mulaiSkor = 100 - (mulai - (22 * 60 + 30)).abs() * 0.87;

    // 4. Kafein: tiap cangkir mengurangi, minum setelah 14:00 mengurangi lagi.
    double kafein = 100;
    if (e.kafein > 0) {
      final terakhir = e.kafeinTerakhir.hour * 60 + e.kafeinTerakhir.minute;
      final terlambat = (terakhir - 14 * 60).clamp(0, 24 * 60);
      kafein = 100 - e.kafein * 8 - terlambat * 0.16;
    }

    // 5. Gadget sebelum tidur: makin lama layar, makin rendah.
    final gadget = 100 - e.gadgetMenit * 0.35;

    // 6. Stres: 1 paling tenang, 5 paling tinggi.
    final stres = 100 - (e.stres - 1) * 6;

    return [
      FaktorSkor('Durasi tidur', _batas(durasi)),
      FaktorSkor('Konsistensi jadwal', _batas(konsistensi)),
      FaktorSkor('Waktu mulai tidur', _batas(mulaiSkor)),
      FaktorSkor('Kafein', _batas(kafein)),
      FaktorSkor('Gadget sebelum tidur', _batas(gadget)),
      FaktorSkor('Tingkat stres', _batas(stres.toDouble())),
    ];
  }

  /// Bobot sesuai urutan faktor di atas. Jumlahnya 1.0.
  static const List<double> bobot = [0.40, 0.15, 0.10, 0.05, 0.05, 0.25];

  static int total(
    EntriTidur e, {
    int targetJam = 8,
    int selisihJadwalMenit = 40,
  }) {
    final f = faktor(e,
        targetJam: targetJam, selisihJadwalMenit: selisihJadwalMenit);
    var jumlah = 0.0;
    for (var i = 0; i < f.length; i++) {
      jumlah += f[i].nilai * bobot[i];
    }
    return jumlah.round();
  }
}
