import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Isi sementara untuk menu yang halamannya belum dibuat.
class HalamanSegera extends StatelessWidget {
  final String judul;
  const HalamanSegera({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty_rounded,
                size: 36, color: AppColors.hijauSedang),
            const SizedBox(height: 14),
            Text(
              judul,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Halaman ini dibuat di langkah berikutnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
