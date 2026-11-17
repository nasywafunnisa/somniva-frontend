import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/laporan_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import 'bagian_ekspor.dart';

const Color _garis = Color(0xFFEFEADC);

/// Ekspor Laporan PDF untuk WEB (desain: Website UI 10).
class EksporWeb extends StatefulWidget {
  const EksporWeb({super.key});

  @override
  State<EksporWeb> createState() => _EksporWebState();
}

class _EksporWebState extends State<EksporWeb> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _kepala(context),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, box) {
            final dua = box.maxWidth >= 820;
            final kiri = _kartuPengaturan();
            final kanan = _kartuPratinjau(laporan);
            if (!dua) {
              return Column(
                  children: [kiri, const SizedBox(height: 20), kanan]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 10, child: kiri),
                const SizedBox(width: 24),
                Expanded(flex: 15, child: kanan),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _kepala(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unduh ringkasan tidurmu',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Ekspor Laporan',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        ),
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
    );
  }

  Widget _kartuPengaturan() {
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Pengaturan laporan',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 16),
          ChipRentangLaporan(
            nilai: _rentang,
            onPilih: (r) => setState(() => _rentang = r),
          ),
          const SizedBox(height: 14),
          DaftarIsiLaporan(
            isi: _isi,
            ukuran: 30,
            onUbah: (v) => setState(() => _isi = v),
          ),
          const SizedBox(height: 18),
          _sibuk
              ? const SizedBox(
                  height: 54,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.hijauTua),
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
          const SizedBox(height: 12),
          const Text(
            'Di web, "Bagikan" ikut mengunduh file PDF-nya. Menu bagikan bawaan muncul di HP.',
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

  Widget _kartuPratinjau(LaporanTidur l) {
    final nama = _isi.daftarNama;
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.hijauGelap,
                      ),
                    ),
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
              Material(
                color: AppColors.krim,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => _jalankan(AksiEkspor.pratinjau),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    child: Text(
                      'Pratinjau',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Divider(height: 1, color: _garis),
          const SizedBox(height: 22),
          BarisAngkaLaporan(laporan: l),
          const SizedBox(height: 22),
          const Divider(height: 1, color: _garis),
          const SizedBox(height: 22),
          const Text(
            'Ringkasan edukatif dari catatanmu, bukan diagnosis atau hasil pemeriksaan medis.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            nama.isEmpty
                ? 'Belum ada bagian yang dipilih.'
                : 'Isi PDF: ${nama.join(', ')}.',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: AppColors.hijauTua,
            ),
          ),
        ],
      ),
    );
  }
}
