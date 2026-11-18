import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../shared/kartu_somniva.dart';

/// Kartu angka ringkas di Dashboard Admin (contoh: "Total pengguna 12.480").
class KartuStatAdmin extends StatelessWidget {
  final String label;
  final String nilai;
  final String ket;

  const KartuStatAdmin({
    super.key,
    required this.label,
    required this.nilai,
    required this.ket,
  });

  @override
  Widget build(BuildContext context) {
    return KartuSomniva(
      radius: 26,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ket,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}
