import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/laporan_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/ring_skor.dart';
import '../../shared/tombol_somniva.dart';
import 'bagian_ekspor.dart';

const Color _garis = Color(0xFFEFEADC);

/// Ekspor Laporan PDF untuk HP (desain: Mobile App UI 17).
class EksporPage extends StatefulWidget {
  const EksporPage({super.key});

  @override
  State<EksporPage> createState() => _EksporPageState();
}

class _EksporPageState extends State<EksporPage> {
  RentangLaporan _rentang = RentangLaporan.tujuhHari;
  IsiLaporan _isi = const IsiLaporan();
  bool _sibuk = false;

  Future<void> _jalankan(
    Future<void> Function(BuildContext, RentangLaporan, IsiLaporan) aksi,
  ) async {
    if (_sibuk) return;
    setState(() => _sibuk = true);
    await aksi(context, _rentang, _isi);
    if (mounted) setState(() => _sibuk = false);
  }

  @override
  Widget build(BuildContext context) {
    final laporan = LaporanTidur.buat(_rentang);

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
                  ChipRentangLaporan(
                    nilai: _rentang,
                    onPilih: (r) => setState(() => _rentang = r),
                  ),
                  const SizedBox(height: 18),
                  _kartuLaporan(laporan),
                  const SizedBox(height: 16),
                  _kartuIsi(),
                  const SizedBox(height: 28),
                  _sibuk
                      ? const SizedBox(
                          height: 54,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.hijauTua,
                            ),
                          ),
                        )
                      : TombolUtama(
                          teks: 'Unduh PDF',
                          onTap: () => _jalankan(AksiEkspor.unduh),
                        ),
                  const SizedBox(height: 12),
                  TombolGaris(
                    teks: 'Bagikan',
                    onTap: () => _jalankan(AksiEkspor.bagikan),
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
          'Ekspor Laporan',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
      ],
    );
  }

  Widget _kartuLaporan(LaporanTidur l) {
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan Tidur',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Somniva · ${l.periode()}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.teksSekunder,
                      ),
                    ),
                  ],
                ),
              ),
              RingSkor(nilai: l.rataSkor, ukuran: 90, tebal: 9),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: _garis),
          const SizedBox(height: 16),
          BarisAngkaLaporan(laporan: l, tengah: true),
          const SizedBox(height: 16),
          const Divider(height: 1, color: _garis),
          const SizedBox(height: 14),
          const Text(
            'Ringkasan edukatif dari catatanmu, bukan diagnosis atau hasil pemeriksaan medis.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuIsi() {
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Isi laporan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 10),
          DaftarIsiLaporan(
            isi: _isi,
            onUbah: (v) => setState(() => _isi = v),
          ),
        ],
      ),
    );
  }
}
