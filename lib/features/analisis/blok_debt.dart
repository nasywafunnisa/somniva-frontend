import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/entri_tidur.dart';
import '../../core/format_tanggal.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import 'grafik_durasi.dart';

/// Potongan-potongan Sleep Debt yang dipakai di web dan di HP.
class BlokDebt {
  BlokDebt._();

  static String teksDebt() =>
      EntriTidur.formatDurasi(StoreTidur.instance.sleepDebtMenit);

  static Widget grafik() {
    return GrafikDurasi(
      menit: StoreTidur.instance.durasi7Hari,
      label: FormatTanggal.tujuhHariTerakhir(DateTime.now()),
      targetJam: DataContoh.targetJam,
    );
  }

  /// Kartu hijau "Cara melunasinya".
  static Widget caraMelunasi() {
    final adaUtang = StoreTidur.instance.sleepDebtMenit > 0;
    return KartuSomniva(
      warna: AppColors.hijauPastel,
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cara melunasinya',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            adaUtang
                ? 'Majukan waktu tidur 30 menit selama 7 malam. Pelunasan bertahap lebih nyaman daripada tidur sangat panjang di akhir pekan.'
                : 'Utang tidurmu minggu ini sudah lunas. Pertahankan jam tidur yang teratur.',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: AppColors.hijauGelap,
            ),
          ),
        ],
      ),
    );
  }
}
