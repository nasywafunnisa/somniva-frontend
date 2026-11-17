import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/format_tanggal.dart';
import '../../core/entri_tidur.dart';
import '../../core/riwayat_tidur.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../ekspor/ekspor_page.dart';
import 'chip_rentang.dart';
import 'grafik_garis_riwayat.dart';

/// Grafik & Riwayat untuk HP (desain: Mobile App UI 12).
/// Dibuka dari tab Analisis (tombol "Grafik & Riwayat" di Sleep Score).
class GrafikRiwayatPage extends StatefulWidget {
  const GrafikRiwayatPage({super.key});

  @override
  State<GrafikRiwayatPage> createState() => _GrafikRiwayatPageState();
}

class _GrafikRiwayatPageState extends State<GrafikRiwayatPage> {
  int _rentang = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListenableBuilder(
              listenable: StoreTidur.instance,
              builder: (context, _) => _isi(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _isi(BuildContext context) {
    final data = RiwayatTidur.ambil(_rentang); // terlama -> hari ini
    final terbaruDulu = data.reversed.toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _kepala(context),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ChipRentang(
              nilai: _rentang,
              kecil: true,
              onPilih: (v) => setState(() => _rentang = v),
            ),
          ),
          const SizedBox(height: 16),
          _kartuGrafik(data),
          const SizedBox(height: 24),
          const Text(
            'Riwayat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 12),
          for (final m in terbaruDulu) _kartuMalam(m),
          const SizedBox(height: 4),
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EksporPage()),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.hijauGelap,
                side: const BorderSide(color: AppColors.hijauSedang, width: 1.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Ekspor laporan PDF',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Catatan sebelum hari ini masih data contoh, sampai jurnalmu terisi tiap hari.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
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
          'Grafik & Riwayat',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
      ],
    );
  }

  Widget _kartuGrafik(List<MalamRiwayat> data) {
    final rataSkor = RiwayatTidur.rataSkor(data);
    final rataDurasi = EntriTidur.formatDurasi(RiwayatTidur.rataDurasiMenit(data));
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              const Text(
                'Sleep Score',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                  children: [
                    const TextSpan(text: 'Rata-rata '),
                    TextSpan(
                      text: '$rataSkor',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    TextSpan(text: ' · Durasi $rataDurasi'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GrafikGarisRiwayat(
            nilai: [for (final d in data) d.skor],
            label: RiwayatTidur.label(data),
          ),
        ],
      ),
    );
  }

  Widget _kartuMalam(MalamRiwayat m) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: KartuSomniva(
        radius: 26,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FormatTanggal.ringkas(m.tanggal),
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${m.entri.rentangTeks} · ${m.entri.durasiTeks}',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _lingkaranSkor(m.skor),
          ],
        ),
      ),
    );
  }

  Widget _lingkaranSkor(int skor) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.hijauPastel,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$skor',
        style: const TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauGelap,
        ),
      ),
    );
  }
}
