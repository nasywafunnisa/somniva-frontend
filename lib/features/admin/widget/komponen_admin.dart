import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

/// Deretan chip filter (contoh: Semua | Aktif | Nonaktif).
class ChipFilterAdmin extends StatelessWidget {
  final List<String> opsi;
  final String terpilih;
  final ValueChanged<String> onPilih;

  const ChipFilterAdmin({
    super.key,
    required this.opsi,
    required this.terpilih,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final o in opsi)
          Material(
            color: o == terpilih ? AppColors.hijauTua : AppColors.krim,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => onPilih(o),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Text(
                  o,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: o == terpilih ? Colors.white : AppColors.hijauGelap,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Lencana status kecil. [menonjol] = hijau pastel (Aktif/Terbit),
/// selain itu krim (Nonaktif/Draf).
class LencanaStatusAdmin extends StatelessWidget {
  final String teks;
  final bool menonjol;

  const LencanaStatusAdmin({
    super.key,
    required this.teks,
    required this.menonjol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
      decoration: BoxDecoration(
        color: menonjol ? AppColors.hijauPastel : AppColors.krim,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.hijauGelap,
        ),
      ),
    );
  }
}

/// Tombol kecil bulat di baris tabel (contoh: Detail, Nonaktifkan).
class TombolKecilAdmin extends StatelessWidget {
  final String teks;
  final VoidCallback onTap;

  const TombolKecilAdmin({super.key, required this.teks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Text(
            teks,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}
