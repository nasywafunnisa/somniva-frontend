import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../shared/kartu_somniva.dart';
import 'bagian_profil.dart';

/// Profil & Privasi untuk WEB (desain: Website UI 11).
class ProfilWeb extends StatelessWidget {
  const ProfilWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _kepala(context),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, box) {
            final dua = box.maxWidth >= 820;
            final kiri = _kartuProfil();
            final kanan = _kartuPrivasi(context);
            if (!dua) {
              return Column(
                  children: [kiri, const SizedBox(height: 20), kanan]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: kiri),
                const SizedBox(width: 24),
                Expanded(child: kanan),
              ],
            );
          },
        ),
      ],
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
                'Akun dan data pribadi',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Profil & Privasi',
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

  Widget _kartuProfil() {
    return const KartuSomniva(
      radius: 30,
      padding: EdgeInsets.fromLTRB(32, 28, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Profil & target tidur',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          SizedBox(height: 16),
          FormProfil(),
        ],
      ),
    );
  }

  Widget _kartuPrivasi(BuildContext context) {
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Privasi data',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 10),
          const DaftarIzinData(),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              TombolGarisKecil(
                teks: 'Unduh data saya',
                onTap: () => AksiPrivasi.unduhData(context),
              ),
              TombolGarisKecil(
                teks: 'Hapus riwayat tidur',
                onTap: () => AksiPrivasi.hapusRiwayat(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TombolHapusAkun(),
          const SizedBox(height: 14),
          const Text(
            'Penghapusan meminta konfirmasi dan tidak bisa dibatalkan.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}
