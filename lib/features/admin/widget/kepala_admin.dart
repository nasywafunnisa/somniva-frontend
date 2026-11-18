import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/store_tema.dart';

/// Tombol bulat bergambar bulan: ganti Terang <-> Gelap.
class TombolBulanAdmin extends StatelessWidget {
  const TombolBulanAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.krim,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: StoreTema.instance.balik,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.dark_mode_outlined,
            size: 20,
            color: AppColors.hijauGelap,
          ),
        ),
      ),
    );
  }
}

/// Kepala halaman admin: teks kecil di atas, judul besar, lalu tombol di kanan
/// (tombol aksi halaman, kemudian tombol mode gelap).
class KepalaAdmin extends StatelessWidget {
  final String kecil;
  final String judul;
  final List<Widget> aksi;

  const KepalaAdmin({
    super.key,
    required this.kecil,
    required this.judul,
    this.aksi = const [],
  });

  @override
  Widget build(BuildContext context) {
    final kanan = <Widget>[];
    for (final a in aksi) {
      kanan.add(a);
      kanan.add(const SizedBox(width: 12));
    }
    kanan.add(const TombolBulanAdmin());

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 16,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kecil,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              judul,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
        Row(mainAxisSize: MainAxisSize.min, children: kanan),
      ],
    );
  }
}
