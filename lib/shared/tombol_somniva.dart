import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Tombol hijau penuh (contoh: "Lanjut").
class TombolUtama extends StatelessWidget {
  final String teks;
  final VoidCallback onTap;
  const TombolUtama({super.key, required this.teks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.hijauTua,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Tombol dengan garis tepi (contoh: "Sudah punya akun? Masuk").
class TombolGaris extends StatelessWidget {
  final String teks;
  final VoidCallback onTap;
  const TombolGaris({super.key, required this.teks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hijauGelap,
          side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
