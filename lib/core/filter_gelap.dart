import 'package:flutter/material.dart';

/// Mengubah seluruh tampilan Somniva menjadi gelap.
///
/// Cara kerjanya: warna terang yang dipakai di aplikasi (krim, putih, hijau
/// tua) dipetakan ke warna gelap lewat satu matriks warna. Jadi semua halaman,
/// dialog, dan snackbar ikut gelap tanpa mengubah satu per satu.
/// Warna hasilnya mendekati desain gelap (latar hijau tua, teks terang,
/// aksen hijau muda), tetapi bukan tema gelap per-widget yang presisi.
class FilterGelap extends StatelessWidget {
  final bool aktif;
  final Widget child;

  const FilterGelap({super.key, required this.aktif, required this.child});

  // Satu baris = hasil R, G, B, A. Kolom: R, G, B, A, tambahan (skala 0-255).
  static const List<double> _gelap = <double>[
    -2.5034, -0.4690, 1.8879, 0, 301.0652, //
    -4.3935, 1.9189, 1.5607, 0, 270.2243, //
    -2.6574, -0.3236, 1.9826, 0, 284.0856, //
    0, 0, 0, 1, 0,
  ];

  static const List<double> _normal = <double>[
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    // Filter selalu terpasang (saat terang berupa matriks "tidak berubah")
    // supaya halaman yang sedang dibuka tidak ter-reset ketika mode berganti.
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(aktif ? _gelap : _normal),
      child: child,
    );
  }
}
