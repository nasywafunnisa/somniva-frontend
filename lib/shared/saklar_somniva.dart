import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Saklar hidup/mati bergaya Somniva (hijau tua saat hidup).
class SaklarSomniva extends StatelessWidget {
  final bool nilai;
  final ValueChanged<bool> onUbah;

  const SaklarSomniva({super.key, required this.nilai, required this.onUbah});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onUbah(!nilai),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 56,
        height: 32,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: nilai ? AppColors.hijauTua : AppColors.titikMati,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: nilai ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
