import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/store_program.dart';
import '../../shared/kartu_somniva.dart';

/// Kartu "Hari N · Judul" berisi tiga tugas dengan kotak centang.
class KartuTugas extends StatelessWidget {
  final int hari;
  const KartuTugas({super.key, required this.hari});

  @override
  Widget build(BuildContext context) {
    final store = StoreProgram.instance;
    final r = StoreProgram.rencana[hari - 1];
    final bisaUbah = hari == store.hariAktif;
    final terkunci = hari > store.hariAktif;

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hari $hari · ${r.judul}',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < r.tugas.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _BarisTugas(
              teks: r.tugas[i],
              dicentang: store.dicentang(hari, i),
              pudar: terkunci,
              onTap: bisaUbah ? () => store.ubahCentang(hari, i) : null,
            ),
          ],
          if (terkunci) ...[
            const SizedBox(height: 14),
            Text(
              'Terbuka di hari ke-$hari.',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.teksSekunder,
              ),
            ),
          ] else if (!bisaUbah) ...[
            const SizedBox(height: 14),
            const Text(
              'Hari yang sudah lewat. Tugasnya tidak bisa diubah lagi.',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BarisTugas extends StatelessWidget {
  final String teks;
  final bool dicentang;
  final bool pudar;
  final VoidCallback? onTap;
  const _BarisTugas({
    required this.teks,
    required this.dicentang,
    required this.pudar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isi = Opacity(
      opacity: pudar ? 0.55 : 1,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: dicentang ? AppColors.hijauTua : Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: dicentang
                  ? null
                  : Border.all(color: AppColors.hijauSedang, width: 2),
            ),
            child: dicentang
                ? const Icon(Icons.check_rounded, size: 22, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return isi;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: isi,
      ),
    );
  }
}
