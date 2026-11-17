import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/store_program.dart';
import '../../shared/kartu_somniva.dart';
import 'grid_hari.dart';
import 'kartu_tugas.dart';

/// Program 14 Hari untuk WEB (desain: Website UI 08).
class ProgramWeb extends StatefulWidget {
  const ProgramWeb({super.key});

  @override
  State<ProgramWeb> createState() => _ProgramWebState();
}

class _ProgramWebState extends State<ProgramWeb> {
  int? _pilih;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreProgram.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final store = StoreProgram.instance;
    final hari = _pilih ?? store.hariAktif;

    final kartuKiri = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Perkembanganmu',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                '${store.persen}%',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: store.hariAktif / StoreProgram.total,
              minHeight: 9,
              backgroundColor: AppColors.hijauMuda,
              valueColor: const AlwaysStoppedAnimation(AppColors.hijauSedang),
            ),
          ),
          const SizedBox(height: 14),
          GridHari(
            dipilih: hari,
            rasio: 1.3,
            onPilih: (h) => setState(() => _pilih = h),
          ),
          const SizedBox(height: 14),
          Text(
            '${store.jumlahSelesai} hari selesai · skor rata-rata naik ${DataContoh.programNaikSkor} poin',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );

    final kartuKanan = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KartuTugas(hari: hari),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Buka Somniva di HP untuk melanjutkan latihan pernapasan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.hijauGelap,
              side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: const Text(
              'Lanjutkan di aplikasi',
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: store.hariAktif >= StoreProgram.total
                ? null
                : () {
                    store.majuSatuHariDemo();
                    setState(() => _pilih = null);
                  },
            child: const Text(
              'Mode demo: lanjut ke hari berikutnya',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.teksSekunder,
              ),
            ),
          ),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _kepala(context, store),
            const SizedBox(height: 22),
            if (sempit) ...[
              kartuKiri,
              const SizedBox(height: 16),
              kartuKanan,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 58, child: kartuKiri),
                  const SizedBox(width: 18),
                  Expanded(flex: 42, child: kartuKanan),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _kepala(BuildContext context, StoreProgram store) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tidur teratur lewat langkah kecil',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Program 14 Hari',
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
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.krim,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Hari ${store.hariAktif} dari ${StoreProgram.total}',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.hijauGelap,
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
