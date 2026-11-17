import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/korelasi.dart';
import '../../shared/kartu_somniva.dart';

/// Kartu perbandingan dua kelompok (contoh: "Kafein sore").
class KartuKorelasi extends StatelessWidget {
  final String judul;
  final HasilBanding hasil;

  /// true = ukuran lebih rapat (dipakai berjajar tiga di web).
  final bool rapat;

  const KartuKorelasi({
    super.key,
    required this.judul,
    required this.hasil,
    this.rapat = false,
  });

  @override
  Widget build(BuildContext context) {
    return KartuSomniva(
      radius: 28,
      padding: EdgeInsets.fromLTRB(22, rapat ? 22 : 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            judul,
            style: TextStyle(
              fontSize: rapat ? 17 : 20,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 14),
          _Baris(
            label: hasil.label1,
            nilai: hasil.nilai1,
            warna: AppColors.hijauSedang,
            rapat: rapat,
          ),
          const SizedBox(height: 12),
          _Baris(
            label: hasil.label2,
            nilai: hasil.nilai2,
            warna: AppColors.cokelat,
            rapat: rapat,
          ),
          const SizedBox(height: 14),
          Text(
            hasil.ringkasan,
            style: TextStyle(
              fontSize: rapat ? 14 : 15.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}

class _Baris extends StatelessWidget {
  final String label;
  final int? nilai;
  final Color warna;
  final bool rapat;
  const _Baris({
    required this.label,
    required this.nilai,
    required this.warna,
    required this.rapat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: rapat ? 104 : 118,
          child: Text(
            label,
            style: TextStyle(
              fontSize: rapat ? 13.5 : 15,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (nilai ?? 0) / 100,
              minHeight: 9,
              backgroundColor: AppColors.hijauMuda,
              valueColor: AlwaysStoppedAnimation(warna),
            ),
          ),
        ),
        SizedBox(
          width: 44,
          child: Text(
            nilai == null ? '–' : '$nilai',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: rapat ? 16 : 19,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
        ),
      ],
    );
  }
}
