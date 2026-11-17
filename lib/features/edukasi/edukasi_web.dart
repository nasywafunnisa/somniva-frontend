import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/artikel_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import 'artikel_page.dart';
import 'bagian_edukasi.dart';

/// Edukasi Tidur untuk WEB (desain: Website UI 09).
class EdukasiWeb extends StatefulWidget {
  const EdukasiWeb({super.key});

  @override
  State<EdukasiWeb> createState() => _EdukasiWebState();
}

class _EdukasiWebState extends State<EdukasiWeb> {
  String _kategori = 'Semua';
  String _kata = '';

  void _buka(ArtikelTidur a) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArtikelPage(artikel: a)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil = ArtikelTidur.cari(kategori: _kategori, kata: _kata);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _kepala(context),
        const SizedBox(height: 22),
        ChipKategori(
          terpilih: _kategori,
          onPilih: (k) => setState(() => _kategori = k),
        ),
        const SizedBox(height: 22),
        if (hasil.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'Belum ada artikel yang cocok. Coba kata kunci atau kategori lain.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          )
        else
          _grid(hasil),
        const SizedBox(height: 22),
        _bannerRelaksasi(context),
      ],
    );
  }

  Widget _kepala(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 16,
      children: [
        const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artikel dan tips',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Edukasi Tidur',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              child: KotakCari(
                hint: 'Cari artikel',
                onUbah: (v) => setState(() => _kata = v),
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
        ),
      ],
    );
  }

  Widget _grid(List<ArtikelTidur> daftar) {
    return LayoutBuilder(
      builder: (context, box) {
        const jarak = 20.0;
        final kolom = box.maxWidth >= 900 ? 3 : (box.maxWidth >= 560 ? 2 : 1);
        final lebar = (box.maxWidth - jarak * (kolom - 1)) / kolom;
        return Wrap(
          spacing: jarak,
          runSpacing: jarak,
          children: [
            for (final a in daftar)
              SizedBox(width: lebar, child: _kartuArtikel(a)),
          ],
        );
      },
    );
  }

  Widget _kartuArtikel(ArtikelTidur a) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _buka(a),
        child: KartuSomniva(
          radius: 30,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GambarArtikel(
                  nada: a.nada, tinggi: 150, radius: 22, ukuranIkon: 40),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  a.judul,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
                child: Text(
                  a.meta,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerRelaksasi(BuildContext context) {
    return KartuSomniva(
      warna: AppColors.krim,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(32, 26, 32, 26),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 16,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Relaksasi sebelum tidur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Panduan pernapasan 4–7–8, pernapasan kotak, dan relaksasi otot. Latihannya paling nyaman dilakukan di aplikasi saat kamu sudah berbaring.',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 290,
            child: TombolUtama(
              teks: 'Lanjutkan latihan di aplikasi',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Latihan Relaksasi ada di tampilan HP. Perkecil jendela atau buka Somniva di HP.',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
