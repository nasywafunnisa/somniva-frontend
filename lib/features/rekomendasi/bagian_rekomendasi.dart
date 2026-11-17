import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/rekomendasi.dart';

/// Tiga pilihan jam tidur: 22:15 | 22:30 | 22:45.
class PilihJamTidur extends StatelessWidget {
  final int terpilih; // 0, 1, atau 2
  final ValueChanged<int> onPilih;
  final bool kecil;

  const PilihJamTidur({
    super.key,
    required this.terpilih,
    required this.onPilih,
    this.kecil = false,
  });

  @override
  Widget build(BuildContext context) {
    final jam = Rekomendasi.pilihan;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: kecil ? 14 : 16,
      runSpacing: 8,
      children: [for (var i = 0; i < jam.length; i++) _satu(i, jam[i])],
    );
  }

  Widget _satu(int i, int menit) {
    final aktif = i == terpilih;
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onPilih(i),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kecil ? 24 : 26,
            vertical: kecil ? 16 : 15,
          ),
          child: Text(
            Rekomendasi.jam(menit),
            style: TextStyle(
              fontSize: kecil ? 17 : 16,
              fontWeight: FontWeight.w500,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}

/// Kotak centang bulat sudut (bisa diketuk untuk menandai).
class KotakCentang extends StatelessWidget {
  final bool centang;
  final VoidCallback onTap;
  final double ukuran;

  const KotakCentang({
    super.key,
    required this.centang,
    required this.onTap,
    this.ukuran = 38,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: ukuran,
        height: ukuran,
        decoration: BoxDecoration(
          color: centang ? AppColors.hijauTua : Colors.transparent,
          borderRadius: BorderRadius.circular(ukuran * 0.28),
          border: Border.all(
            color: centang ? AppColors.hijauTua : AppColors.hijauSedang,
            width: 2.6,
          ),
        ),
        child: centang
            ? Icon(Icons.check_rounded, size: ukuran * 0.6, color: Colors.white)
            : null,
      ),
    );
  }
}
