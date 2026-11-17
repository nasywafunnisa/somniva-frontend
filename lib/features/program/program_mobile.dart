import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/store_program.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../shared/util.dart';
import 'grid_hari.dart';
import 'kartu_tugas.dart';

/// Program 14 Hari untuk HP (desain: Mobile App UI 08). Tab "Program".
class ProgramMobile extends StatefulWidget {
  const ProgramMobile({super.key});

  @override
  State<ProgramMobile> createState() => _ProgramMobileState();
}

class _ProgramMobileState extends State<ProgramMobile> {
  int? _pilih; // null = ikut hari ini

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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Program 14 Hari',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Langkah kecil setiap malam menuju jadwal tidur yang teratur',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 16),
                _kartuProgres(store),
                const SizedBox(height: 14),
                KartuSomniva(
                  radius: 28,
                  padding: const EdgeInsets.all(18),
                  child: GridHari(
                    dipilih: hari,
                    onPilih: (h) => setState(() => _pilih = h),
                  ),
                ),
                const SizedBox(height: 14),
                KartuTugas(hari: hari),
                const SizedBox(height: 6),
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
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
          child: TombolUtama(
            teks: 'Mulai latihan pernapasan',
            onTap: () => tampilkanSegera(context, 'Latihan Relaksasi'),
          ),
        ),
      ],
    );
  }

  Widget _kartuProgres(StoreProgram store) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hari ${store.hariAktif} dari ${StoreProgram.total}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                '${store.persen}%',
                style: const TextStyle(
                  fontSize: 19,
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
          const SizedBox(height: 12),
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
  }
}
