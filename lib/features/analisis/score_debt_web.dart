import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/ring_skor.dart';
import '../../shared/util.dart';
import 'blok_debt.dart';
import 'daftar_faktor.dart';

/// Sleep Score & Sleep Debt untuk WEB (desain: Website UI 04).
class ScoreDebtWeb extends StatelessWidget {
  const ScoreDebtWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final store = StoreTidur.instance;
    final skor = store.skor;
    final naik = skor - DataContoh.skorKemarin;
    final arah = naik >= 0 ? 'Naik $naik poin' : 'Turun ${-naik} poin';
    final sekarang = DateTime.now();
    final tgl = FormatTanggal.panjang(sekarang, tahun: false);

    final kartuSkor = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              RingSkor(nilai: skor, ukuran: 170, tebal: 22),
              const SizedBox(width: 26),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FormatTanggal.labelSkor(skor),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$tgl · ${store.entri.durasiTeks} tidur. $arah dari kemarin.',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Faktor yang memengaruhi',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 16),
          DaftarFaktor(faktor: store.faktor),
        ],
      ),
    );

    final kartuDebt = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Akumulasi 7 hari terakhir',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            BlokDebt.teksDebt(),
            style: const TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1,
              color: AppColors.hijauGelap,
            ),
          ),
          Text(
            'kurang dari target ${DataContoh.targetJam} jam per malam',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 18),
          BlokDebt.grafik(),
          const SizedBox(height: 18),
          BlokDebt.caraMelunasi(),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _kepala(context),
            const SizedBox(height: 22),
            if (sempit) ...[
              kartuSkor,
              const SizedBox(height: 18),
              kartuDebt,
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: kartuSkor),
                    const SizedBox(width: 20),
                    Expanded(child: kartuDebt),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Sleep Score adalah indikator edukatif dari kebiasaan yang kamu catat, bukan hasil pemeriksaan medis.',
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

  Widget _kepala(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analisis',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Sleep Score & Sleep Debt',
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
          child: OutlinedButton(
            onPressed: () => tampilkanSegera(context, 'Ekspor PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.hijauGelap,
              side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
              padding: const EdgeInsets.symmetric(horizontal: 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Ekspor PDF',
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
            onTap: () => tampilkanSegera(context, 'Mode gelap'),
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
