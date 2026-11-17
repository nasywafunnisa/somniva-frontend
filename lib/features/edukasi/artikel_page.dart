import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/artikel_tidur.dart';
import '../../core/responsive_util.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../pengingat/wind_down_page.dart';
import '../relaksasi/latihan_relaksasi_page.dart';
import 'bagian_edukasi.dart';

/// Halaman baca satu artikel (dipakai HP dan web).
class ArtikelPage extends StatelessWidget {
  final ArtikelTidur artikel;

  const ArtikelPage({super.key, required this.artikel});

  void _aksi(BuildContext context) {
    // Latihan Relaksasi dan Wind-Down hanya ada di tampilan HP.
    if (sedangLebar(context)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Fitur ini ada di tampilan HP. Perkecil jendela atau buka Somniva di HP.',
          ),
        ),
      );
      return;
    }
    final halaman = artikel.aksi == AksiArtikel.latihanNapas
        ? const LatihanRelaksasiPage()
        : const WindDownPage();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => halaman));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _kepala(context),
                  const SizedBox(height: 18),
                  GambarArtikel(
                    nada: artikel.nada,
                    tinggi: 170,
                    radius: 28,
                    ukuranIkon: 52,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    artikel.meta.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artikel.judul,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final p in artikel.paragraf)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        p,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  _kartuTips(),
                  if (artikel.aksi != AksiArtikel.tidak) ...[
                    const SizedBox(height: 18),
                    TombolUtama(
                      teks: artikel.aksi == AksiArtikel.latihanNapas
                          ? 'Coba latihan napas'
                          : 'Buka Wind-Down Routine',
                      onTap: () => _aksi(context),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text(
                    'Konten ini bersifat edukatif dan bukan pengganti saran tenaga medis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
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
          'Edukasi Tidur',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
      ],
    );
  }

  Widget _kartuTips() {
    return KartuSomniva(
      warna: AppColors.hijauPastel,
      radius: 26,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips untuk dicoba',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 12),
          for (final t in artikel.tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.hijauTua,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
