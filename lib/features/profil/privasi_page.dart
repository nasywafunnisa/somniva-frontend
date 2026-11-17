import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/kartu_somniva.dart';
import 'bagian_profil.dart';

/// Privasi Data untuk HP (desain: Mobile App UI 18).
class PrivasiPage extends StatelessWidget {
  const PrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      TombolKembaliKotak(),
                      SizedBox(width: 16),
                      Text(
                        'Privasi Data',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const KartuSomniva(
                    radius: 30,
                    padding: EdgeInsets.fromLTRB(22, 22, 22, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Izin penggunaan data',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        SizedBox(height: 8),
                        DaftarIzinData(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const KartuSomniva(
                    warna: AppColors.krim,
                    radius: 30,
                    padding: EdgeInsets.fromLTRB(22, 22, 22, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data yang tersimpan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Jam tidur dan bangun, suasana hati, stres, kafein, aktivitas, dan durasi layar. Tidak ada data kesehatan lain yang diambil.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  KartuSomniva(
                    radius: 30,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Column(
                      children: [
                        BarisMenuProfil(
                          ikon: Icons.file_download_outlined,
                          teks: 'Unduh data saya',
                          onTap: () => AksiPrivasi.unduhData(context),
                        ),
                        BarisMenuProfil(
                          ikon: Icons.delete_outline_rounded,
                          teks: 'Hapus riwayat tidur',
                          onTap: () => AksiPrivasi.hapusRiwayat(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const TombolHapusAkun(),
                  const SizedBox(height: 12),
                  const Text(
                    'Penghapusan akan diminta konfirmasi dan tidak bisa dibatalkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
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
}
