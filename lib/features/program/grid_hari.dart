import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/store_program.dart';

/// Kisi 14 hari (2 baris x 7). Ketuk hari untuk melihat tugasnya.
class GridHari extends StatelessWidget {
  final int dipilih;
  final ValueChanged<int> onPilih;

  /// Lebar dibanding tinggi tiap kotak (1.0 = persegi).
  final double rasio;

  const GridHari({
    super.key,
    required this.dipilih,
    required this.onPilih,
    this.rasio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final store = StoreProgram.instance;
    Widget baris(int mulai) {
      return Row(
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _kotak(store, mulai + i)),
          ],
        ],
      );
    }

    return Column(
      children: [
        baris(1),
        const SizedBox(height: 8),
        baris(8),
      ],
    );
  }

  Widget _kotak(StoreProgram store, int hari) {
    final aktif = hari == store.hariAktif;
    final selesai = store.selesai(hari);
    final terpilih = hari == dipilih;

    final Color isi = selesai
        ? AppColors.hijauTua
        : (aktif ? Colors.white : AppColors.krim);
    final Color teks = selesai
        ? Colors.white
        : (aktif ? AppColors.hijauGelap : AppColors.teksSekunder);

    Border? garis;
    if (aktif && !selesai) {
      garis = Border.all(color: AppColors.hijauTua, width: 2);
    } else if (terpilih) {
      garis = Border.all(color: AppColors.hijauSedang, width: 2);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onPilih(hari),
        child: AspectRatio(
          aspectRatio: rasio,
          child: Container(
            decoration: BoxDecoration(
              color: isi,
              borderRadius: BorderRadius.circular(14),
              border: garis,
            ),
            alignment: Alignment.center,
            child: Text(
              '$hari',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: teks,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
