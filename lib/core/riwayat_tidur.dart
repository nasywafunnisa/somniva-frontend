import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data_contoh.dart';
import 'entri_tidur.dart';
import 'format_tanggal.dart';
import 'store_tidur.dart';

/// Satu malam di halaman Grafik & Riwayat.
class MalamRiwayat {
  final DateTime tanggal;
  final EntriTidur entri;
  final int skor;

  const MalamRiwayat({
    required this.tanggal,
    required this.entri,
    required this.skor,
  });

  int get durasiMenit => entri.durasiMenit;
}

/// Menyusun riwayat tidur untuk 7, 30, atau 90 hari terakhir.
///
/// Sumber data:
/// - 21 malam terakhir diambil dari StoreTidur (20 contoh + jurnal hari ini).
/// - Malam yang lebih lama dari itu dibuat otomatis (CONTOH, hasilnya selalu
///   sama), supaya pilihan 30 dan 90 hari ada isinya.
/// Nanti semuanya diganti data asli dari database.
class RiwayatTidur {
  RiwayatTidur._();

  /// Hasil diurutkan dari yang terlama ke hari ini.
  static List<MalamRiwayat> ambil(int hari) {
    final sekarang = DateTime.now();
    final nyata = StoreTidur.instance.riwayat; // terlama -> hari ini
    final hasil = <MalamRiwayat>[];

    for (var k = hari - 1; k >= 0; k--) {
      final tanggal = DateTime(sekarang.year, sekarang.month, sekarang.day - k);
      final indeks = nyata.length - 1 - k;
      final entri = indeks >= 0 ? nyata[indeks] : _contohLama(k);
      hasil.add(MalamRiwayat(
        tanggal: tanggal,
        entri: entri,
        skor: HitungSkor.total(entri, targetJam: DataContoh.targetJam),
      ));
    }
    return hasil;
  }

  /// Catatan contoh untuk malam yang lebih lama dari data yang ada.
  static EntriTidur _contohLama(int k) {
    final r = math.Random(k * 7919 + 13);
    final mulai = 22 * 60 + r.nextInt(100); // 22:00 sampai 23:39
    final lama = 360 + r.nextInt(150); // 6j sampai 8j30m
    final bangun = (mulai + lama) % (24 * 60);
    return EntriTidur(
      tidur: TimeOfDay(hour: mulai ~/ 60, minute: mulai % 60),
      bangun: TimeOfDay(hour: bangun ~/ 60, minute: bangun % 60),
      suasana: 'Biasa',
      stres: 2 + r.nextInt(3),
      kafein: r.nextInt(3),
      kafeinTerakhir: TimeOfDay(hour: 10 + r.nextInt(7), minute: 0),
      aktif: r.nextBool(),
      gadgetMenit: 20 + r.nextInt(110),
    );
  }

  static int rataSkor(List<MalamRiwayat> data) {
    if (data.isEmpty) return 0;
    var total = 0;
    for (final d in data) {
      total += d.skor;
    }
    return (total / data.length).round();
  }

  static int rataDurasiMenit(List<MalamRiwayat> data) {
    if (data.isEmpty) return 0;
    var total = 0;
    for (final d in data) {
      total += d.durasiMenit;
    }
    return (total / data.length).round();
  }

  /// Label sumbu X. 7 hari: Sel, Rab, ... ; 30/90 hari: "10/11" tiap
  /// beberapa titik, sisanya kosong supaya tidak berdesakan.
  static List<String> label(List<MalamRiwayat> data) {
    final n = data.length;
    if (n <= 7) {
      return [for (final d in data) FormatTanggal.hariPendek(d.tanggal)];
    }
    final langkah = (n / 6).ceil();
    return [
      for (var i = 0; i < n; i++)
        (n - 1 - i) % langkah == 0
            ? '${data[i].tanggal.day}/${data[i].tanggal.month}'
            : '',
    ];
  }
}
