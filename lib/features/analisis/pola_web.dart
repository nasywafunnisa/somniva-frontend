import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/nav_app.dart';
import '../../core/korelasi.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import 'grafik_sebar.dart';
import 'kartu_korelasi.dart';

/// Pola & Korelasi untuk WEB (desain: Website UI 05).
class PolaWeb extends StatelessWidget {
  const PolaWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final r = StoreTidur.instance.riwayat;
    final kafein = KartuKorelasi(
      judul: 'Kafein sore',
      hasil: Korelasi.kafein(r),
      rapat: true,
    );
    final layar = KartuKorelasi(
      judul: 'Layar sebelum tidur',
      hasil: Korelasi.layar(r),
      rapat: true,
    );
    final aktivitas = KartuKorelasi(
      judul: 'Aktivitas fisik',
      hasil: Korelasi.aktivitas(r),
      rapat: true,
    );

    final sebar = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Jam mulai tidur dan Sleep Score',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Setiap titik adalah satu malam. Garis putus-putus menunjukkan arah kecenderungannya.',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 14),
          GrafikSebar(titik: Korelasi.titik(r)),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _kepala(context, r.length),
            const SizedBox(height: 22),
            if (sempit) ...[
              kafein,
              const SizedBox(height: 16),
              layar,
              const SizedBox(height: 16),
              aktivitas,
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: kafein),
                    const SizedBox(width: 18),
                    Expanded(child: layar),
                    const SizedBox(width: 18),
                    Expanded(child: aktivitas),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            sebar,
            const SizedBox(height: 14),
            const Text(
              'Ini hubungan statistik dari catatanmu, bukan sebab-akibat atau diagnosis.',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _kepala(BuildContext context, int jumlah) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analisis dari $jumlah catatan terakhir',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Pola & Korelasi',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => NavApp.menuWeb.value = 5, // menu Program 14 Hari
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.hijauTua,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Mulai Program 14 Hari',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: AppColors.krim,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: StoreTema.instance.balik,
            child: const SizedBox(
              width: 46,
              height: 46,
              child: Icon(Icons.dark_mode_outlined,
                  size: 20, color: AppColors.hijauGelap),
            ),
          ),
        ),
      ],
    );
  }
}
