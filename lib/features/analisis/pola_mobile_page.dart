import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/nav_app.dart';
import '../../core/korelasi.dart';
import '../../core/store_tidur.dart';
import '../../shared/tombol_somniva.dart';
import 'kartu_korelasi.dart';

/// Pola & Korelasi untuk HP (desain: Mobile App UI 07). Dibuka dari Sleep Score.
class PolaMobilePage extends StatelessWidget {
  const PolaMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListenableBuilder(
              listenable: StoreTidur.instance,
              builder: (context, _) {
                final r = StoreTidur.instance.riwayat;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _kepala(context, r.length),
                            const SizedBox(height: 18),
                            KartuKorelasi(
                              judul: 'Kafein sore',
                              hasil: Korelasi.kafein(r),
                            ),
                            const SizedBox(height: 14),
                            KartuKorelasi(
                              judul: 'Layar sebelum tidur',
                              hasil: Korelasi.layar(r),
                            ),
                            const SizedBox(height: 14),
                            KartuKorelasi(
                              judul: 'Aktivitas fisik',
                              hasil: Korelasi.aktivitas(r),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Ini hubungan statistik dari catatanmu, bukan sebab-akibat atau diagnosis.',
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                      child: TombolUtama(
                        teks: 'Mulai Program 14 Hari',
                        onTap: () {
                          NavApp.tabHp.value = 3; // tab Program
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _kepala(BuildContext context, int jumlah) {
    return Row(
      children: [
        Material(
          color: AppColors.krim,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pop(),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pola & Korelasi',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
            Text(
              'Dari $jumlah catatan terakhir',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
