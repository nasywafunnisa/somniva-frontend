import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/ring_skor.dart';
import '../../shared/tombol_somniva.dart';
import '../../core/entri_tidur.dart';
import '../../core/store_program.dart';
import '../../core/store_tidur.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_pengingat.dart';
import '../../core/store_winddown.dart';
import '../edukasi/edukasi_page.dart';
import '../ekspor/ekspor_page.dart';
import '../pengingat/wind_down_page.dart';
import '../relaksasi/latihan_relaksasi_page.dart';
import '../rekomendasi/rekomendasi_page.dart';

/// Isi Dashboard untuk tampilan HP (desain: Mobile App UI 03 Dashboard).
class DashboardMobile extends StatelessWidget {
  /// Dipanggil saat tombol "Catat tidur & kebiasaan hari ini" ditekan.
  final VoidCallback onCatat;

  /// Dipanggil saat kartu Sleep Score ditekan.
  final VoidCallback onLihatSkor;

  /// Dipanggil saat kartu Program 14 Hari ditekan.
  final VoidCallback onLihatProgram;
  const DashboardMobile({
    super.key,
    required this.onCatat,
    required this.onLihatSkor,
    required this.onLihatProgram,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable:
          Listenable.merge([StoreTidur.instance, StoreProgram.instance]),
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final sekarang = DateTime.now();

    // Isi bisa digulir, tombol "Catat tidur" menempel di bawah.
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _kepala(sekarang),
                const SizedBox(height: 16),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLihatSkor,
                  child: _kartuSkor(),
                ),
                const SizedBox(height: 14),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _kartuDebt()),
                      const SizedBox(width: 14),
                      Expanded(child: _kartuIdeal(context)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onLihatProgram,
                  child: _kartuProgram(),
                ),
                const SizedBox(height: 14),
                ListenableBuilder(
                  listenable: StoreWindDown.instance,
                  builder: (context, _) => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Pil(
                        'Wind-down ${StoreWindDown.instance.jumlah}/${StoreWindDown.instance.total}',
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const WindDownPage()),
                          );
                        },
                      ),
                      _Pil('Napas & relaksasi', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LatihanRelaksasiPage(),
                          ),
                        );
                      }),
                      _Pil('Edukasi', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const EdukasiPage()),
                        );
                      }),
                      _Pil('Ekspor PDF', () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EksporPage()),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TombolUtama(
                teks: 'Catat tidur & kebiasaan hari ini',
                onTap: onCatat,
              ),
              const SizedBox(height: 10),
              const Text(
                'Skor bersifat edukatif, bukan diagnosis medis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kepala(DateTime sekarang) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FormatTanggal.panjang(sekarang, tahun: false),
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${FormatTanggal.salam(sekarang)}, ${DataContoh.namaDepan}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.5,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.krim,
            shape: BoxShape.circle,
          ),
          child: Text(
            DataContoh.namaDepan.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
        ),
      ],
    );
  }

  Widget _kartuSkor() {
    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          RingSkor(nilai: StoreTidur.instance.skor, ukuran: 112, tebal: 14),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep Score semalam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.krim,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    FormatTanggal.labelSkor(StoreTidur.instance.skor),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${StoreTidur.instance.entri.durasiTeks} · ${StoreTidur.instance.entri.rentangTeks}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuDebt() {
    return KartuSomniva(
      radius: 26,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: _IsiKecil(
        label: 'Sleep Debt',
        nilai: EntriTidur.formatDurasi(StoreTidur.instance.sleepDebtMenit),
        ket: DataContoh.sleepDebtKet,
      ),
    );
  }

  Widget _kartuIdeal(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const RekomendasiPage()),
        );
      },
      child: KartuSomniva(
        warna: AppColors.krim,
        radius: 26,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: ListenableBuilder(
          listenable: StorePengingat.instance,
          builder: (context, _) {
            final p = StorePengingat.instance;
            return _IsiKecil(
              label: 'Tidur ideal malam ini',
              nilai: Rekomendasi.jam(p.tidurMenit),
              ket: p.windDownAktif
                  ? 'Pengingat ${Rekomendasi.jam(p.windDownMenit)}'
                  : 'Pengingat mati',
            );
          },
        ),
      ),
    );
  }

  Widget _kartuProgram() {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Program 14 Hari',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                'Hari ${StoreProgram.instance.hariAktif} dari ${StoreProgram.total}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Hari ini: ${StoreProgram.instance.judulHariIni.toLowerCase()}',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: StoreProgram.instance.hariAktif / StoreProgram.total,
              minHeight: 8,
              backgroundColor: AppColors.hijauMuda,
              valueColor: const AlwaysStoppedAnimation(AppColors.hijauSedang),
            ),
          ),
        ],
      ),
    );
  }
}

class _IsiKecil extends StatelessWidget {
  final String label;
  final String nilai;
  final String ket;
  const _IsiKecil({
    required this.label,
    required this.nilai,
    required this.ket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.teksSekunder,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          nilai,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: AppColors.hijauGelap,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          ket,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.teksSekunder,
          ),
        ),
      ],
    );
  }
}

class _Pil extends StatelessWidget {
  final String teks;
  final VoidCallback onTap;
  const _Pil(this.teks, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Text(
            teks,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}
