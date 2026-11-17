import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Pilihan rentang waktu: 7 hari, 30 hari, 90 hari.
class ChipRentang extends StatelessWidget {
  final int nilai;
  final ValueChanged<int> onPilih;
  final bool kecil;

  const ChipRentang({
    super.key,
    required this.nilai,
    required this.onPilih,
    this.kecil = false,
  });

  static const List<int> pilihan = [7, 30, 90];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [for (final h in pilihan) _satu(h)],
    );
  }

  Widget _satu(int hari) {
    final aktif = hari == nilai;
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onPilih(hari),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kecil ? 18 : 22,
            vertical: kecil ? 11 : 13,
          ),
          child: Text(
            '$hari hari',
            style: TextStyle(
              fontSize: kecil ? 14.5 : 15.5,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}
