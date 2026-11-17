import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../core/riwayat_tidur.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import 'chip_rentang.dart';
import 'grafik_durasi.dart';

/// Grafik & Riwayat untuk WEB (desain: Website UI 06).
/// Grafik batang durasi tidur + tabel riwayat per malam.
class GrafikRiwayatWeb extends StatefulWidget {
  const GrafikRiwayatWeb({super.key});

  @override
  State<GrafikRiwayatWeb> createState() => _GrafikRiwayatWebState();
}

class _GrafikRiwayatWebState extends State<GrafikRiwayatWeb> {
  int _rentang = 7;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final data = RiwayatTidur.ambil(_rentang); // terlama -> hari ini
    final terbaruDulu = data.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _kepala(context),
        const SizedBox(height: 22),
        KartuSomniva(
          radius: 30,
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Durasi tidur (jam)',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 10),
              GrafikDurasi(
                menit: [for (final d in data) d.durasiMenit],
                label: RiwayatTidur.label(data),
                targetJam: DataContoh.targetJam,
                tinggi: 340,
                tampilNilai: data.length <= 14,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        KartuSomniva(
          radius: 30,
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Riwayat per malam',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 14),
              for (final m in terbaruDulu) _baris(m),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Catatan sebelum hari ini masih data contoh, sampai jurnalmu terisi tiap hari. Sleep Score adalah indikator edukatif, bukan hasil medis.',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.teksSekunder,
          ),
        ),
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
              'Semua catatan tidurmu',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Grafik & Riwayat',
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
            ChipRentang(
              nilai: _rentang,
              onPilih: (v) => setState(() => _rentang = v),
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

  Widget _baris(MalamRiwayat m) {
    const gayaKedua = TextStyle(
      fontSize: 15.5,
      fontWeight: FontWeight.w500,
      color: AppColors.teksSekunder,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEFEADC))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              FormatTanggal.ringkas(m.tanggal),
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          Expanded(flex: 3, child: Text(m.entri.rentangTeks, style: gayaKedua)),
          Expanded(flex: 2, child: Text(m.entri.durasiTeks, style: gayaKedua)),
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.hijauPastel,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${m.skor}',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
