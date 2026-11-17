import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/artikel_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import 'artikel_page.dart';
import 'bagian_edukasi.dart';

/// Edukasi Tidur untuk HP (desain: Mobile App UI 16).
/// Dibuka dari Beranda (pil "Edukasi").
class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
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
    final tampilPilihan = _kategori == 'Semua' && _kata.trim().isEmpty;
    final pilihan = ArtikelTidur.pilihan;
    final daftar = tampilPilihan
        ? [for (final a in hasil) if (a != pilihan) a]
        : hasil;

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
                  _kepala(context),
                  const SizedBox(height: 18),
                  KotakCari(
                    hint: 'Cari artikel atau tips',
                    onUbah: (v) => setState(() => _kata = v),
                  ),
                  const SizedBox(height: 16),
                  ChipKategori(
                    geser: true,
                    terpilih: _kategori,
                    onPilih: (k) => setState(() => _kategori = k),
                  ),
                  const SizedBox(height: 16),
                  if (tampilPilihan) ...[
                    _kartuPilihan(pilihan),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    tampilPilihan ? 'Terbaru' : '${hasil.length} artikel',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (daftar.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Belum ada artikel yang cocok. Coba kata kunci lain.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.teksSekunder,
                        ),
                      ),
                    ),
                  for (final a in daftar) _kartuArtikel(a),
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

  Widget _kartuPilihan(ArtikelTidur a) {
    return KartuSomniva(
      warna: AppColors.hijauPastel,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'PILIHAN HARI INI',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            a.judul,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${a.ringkas} · ${a.menit} menit baca',
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 18),
          TombolUtama(teks: 'Baca artikel', onTap: () => _buka(a)),
        ],
      ),
    );
  }

  Widget _kartuArtikel(ArtikelTidur a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => _buka(a),
        child: KartuSomniva(
          radius: 26,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GambarArtikel(
                nada: a.nada,
                lebar: 64,
                tinggi: 64,
                radius: 18,
                ukuranIkon: 26,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.judul,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.meta,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
