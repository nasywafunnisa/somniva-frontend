import 'package:flutter/material.dart';

/// Pembungkus mode gelap untuk seluruh layar (web pengguna, aplikasi, web admin).
/// Warna gelap mengikuti desain Dashboard Admin mode gelap:
/// latar 0C130F, kartu 19261E, teks F1F3E8, aksen BCD2AE.
/// Selalu terpasang (matriks identitas saat terang) supaya state halaman
/// tidak ter-reset ketika tema diganti.
class FilterGelap extends StatelessWidget {
  final bool aktif;
  final Widget child;

  const FilterGelap({super.key, required this.aktif, required this.child});

  static const List<double> _gelap = <double>[
    -2.5034, -0.4690, 1.8879, 0, 301.0652,
    -4.3935, 1.9189, 1.5607, 0, 270.2243,
    -2.6574, -0.3236, 1.9826, 0, 284.0856,
    0, 0, 0, 1, 0,
  ];

  static const List<double> _normal = <double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(aktif ? _gelap : _normal),
      child: child,
    );
  }
}
