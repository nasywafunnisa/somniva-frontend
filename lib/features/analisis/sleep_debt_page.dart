import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../shared/util.dart';
import 'blok_debt.dart';

/// Sleep Debt untuk HP (desain: Mobile App UI 06). Dibuka dari Sleep Score.
class SleepDebtPage extends StatelessWidget {
  const SleepDebtPage({super.key});

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
              builder: (context, _) => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _kepala(context),
                          const SizedBox(height: 18),
                          KartuSomniva(
                            warna: AppColors.krim,
                            radius: 28,
                            padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Akumulasi 7 hari terakhir',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.teksSekunder,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  BlokDebt.teksDebt(),
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    letterSpacing: -1,
                                    color: AppColors.hijauGelap,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'kurang dari target ${DataContoh.targetJam} jam per malam',
                                  style: const TextStyle(
                                    fontSize: 15.5,
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
                            padding: const EdgeInsets.fromLTRB(18, 22, 18, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Text(
                                    'Durasi tidur (jam)',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.hijauGelap,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                BlokDebt.grafik(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          BlokDebt.caraMelunasi(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                    child: TombolUtama(
                      teks: 'Mulai Program 14 Hari',
                      onTap: () => tampilkanSegera(context, 'Program 14 Hari'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _kepala(BuildContext context) {
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
        const Text(
          'Sleep Debt',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
      ],
    );
  }
}
