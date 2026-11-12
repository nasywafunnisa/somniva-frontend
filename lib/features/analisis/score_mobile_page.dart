import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/ring_skor.dart';
import '../../shared/util.dart';
import 'daftar_faktor.dart';
import 'sleep_debt_page.dart';

/// Sleep Score untuk HP (desain: Mobile App UI 05). Tab "Analisis".
class ScoreMobilePage extends StatelessWidget {
  final VoidCallback onKembali;
  const ScoreMobilePage({super.key, required this.onKembali});

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
    final arah = naik >= 0 ? 'naik $naik poin' : 'turun ${-naik} poin';
    final sekarang = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Material(
                color: AppColors.krim,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onKembali,
                  child: const SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Sleep Score',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          KartuSomniva(
            warna: AppColors.krim,
            radius: 30,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            child: Column(
              children: [
                RingSkor(nilai: skor, ukuran: 140, tebal: 15),
                const SizedBox(height: 16),
                Text(
                  '${FormatTanggal.labelSkor(skor)} · $arah dari kemarin',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${FormatTanggal.panjang(sekarang, tahun: false)} · ${store.entri.durasiTeks} tidur',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          KartuSomniva(
            radius: 28,
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _tombolGaris('Sleep Debt', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SleepDebtPage()),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _tombolGaris('Pola & Korelasi', () {
                  tampilkanSegera(context, 'Pola & Korelasi');
                }),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Skor dihitung dari kebiasaan yang kamu catat. Hanya indikator edukatif, bukan hasil medis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolGaris(String teks, VoidCallback onTap) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hijauGelap,
          side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
