import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/artikel_tidur.dart';

const Color _garis = Color(0xFFEFEADC);

/// Warna kotak gambar artikel (bergantian tiga nada hijau/krem).
Color warnaNada(int nada) {
  switch (nada % 3) {
    case 0:
      return AppColors.hijauPastel;
    case 1:
      return AppColors.krim;
    default:
      return AppColors.hijauMuda;
  }
}

/// Kotak gambar artikel dengan ikon bulan di tengah.
class GambarArtikel extends StatelessWidget {
  final int nada;
  final double? lebar;
  final double tinggi;
  final double radius;
  final double ukuranIkon;

  const GambarArtikel({
    super.key,
    required this.nada,
    this.lebar,
    required this.tinggi,
    this.radius = 20,
    this.ukuranIkon = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lebar,
      height: tinggi,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: warnaNada(nada),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(
        Icons.nightlight_round,
        size: ukuranIkon,
        color: AppColors.hijauTua,
      ),
    );
  }
}

/// Kolom cari artikel.
class KotakCari extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onUbah;

  const KotakCari({super.key, required this.hint, required this.onUbah});

  @override
  Widget build(BuildContext context) {
    final bentuk = BorderRadius.circular(28);
    return TextField(
      onChanged: onUbah,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.hijauGelap,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF8A9283),
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
        enabledBorder: OutlineInputBorder(
          borderRadius: bentuk,
          borderSide: const BorderSide(color: _garis, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: bentuk,
          borderSide: const BorderSide(color: AppColors.hijauSedang, width: 1.8),
        ),
      ),
    );
  }
}

/// Pilihan kategori: Semua | Kebiasaan | Kafein | Kamar | Relaksasi.
/// [geser] true = satu baris yang bisa digeser ke samping (HP).
class ChipKategori extends StatelessWidget {
  final String terpilih;
  final ValueChanged<String> onPilih;
  final bool geser;

  const ChipKategori({
    super.key,
    required this.terpilih,
    required this.onPilih,
    this.geser = false,
  });

  @override
  Widget build(BuildContext context) {
    final chip = [for (final k in ArtikelTidur.kategoriFilter) _satu(k)];
    if (geser) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < chip.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              chip[i],
            ],
          ],
        ),
      );
    }
    return Wrap(spacing: 12, runSpacing: 10, children: chip);
  }

  Widget _satu(String nama) {
    final aktif = nama == terpilih;
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onPilih(nama),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          child: Text(
            nama,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}
