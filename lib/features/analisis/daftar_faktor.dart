import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/entri_tidur.dart';

/// Enam faktor Sleep Score, masing-masing dengan batang dan angka.
class DaftarFaktor extends StatelessWidget {
  final List<FaktorSkor> faktor;
  const DaftarFaktor({super.key, required this.faktor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < faktor.length; i++) ...[
          if (i > 0) const SizedBox(height: 14),
          _Baris(faktor[i]),
        ],
      ],
    );
  }
}

class _Baris extends StatelessWidget {
  final FaktorSkor f;
  const _Baris(this.f);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              f.nama,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            Text(
              '${f.nilai}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: f.nilai / 100,
            minHeight: 9,
            backgroundColor: AppColors.hijauMuda,
            valueColor: const AlwaysStoppedAnimation(AppColors.hijauSedang),
          ),
        ),
      ],
    );
  }
}
