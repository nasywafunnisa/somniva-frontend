import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/nav_app.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../pengingat/aksi_pengingat.dart';
import 'bagian_rekomendasi.dart';

/// Rekomendasi Waktu Tidur untuk WEB (desain: Website UI 07).
class RekomendasiWeb extends StatefulWidget {
  const RekomendasiWeb({super.key});

  @override
  State<RekomendasiWeb> createState() => _RekomendasiWebState();
}

class _RekomendasiWebState extends State<RekomendasiWeb> {
  int _pilih = 1; // 22:30 (saran utama)
  final List<bool> _centang = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final tidur = Rekomendasi.pilihan[_pilih];

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;
        final kartuWaktu = _kartuWaktu(tidur);
        final kartuDasar = _kartuDasar(tidur);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _kepala(context),
            const SizedBox(height: 22),
            if (sempit) ...[
              kartuWaktu,
              const SizedBox(height: 18),
              kartuDasar,
            ] else
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: kartuWaktu),
                    const SizedBox(width: 20),
                    Expanded(child: kartuDasar),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 300,
                  child: TombolUtama(
                    teks: 'Aktifkan pengingat di aplikasi',
                    onTap: () => aktifkanPengingatDariRekomendasi(
                      context,
                      tidur,
                      denganTombolAtur: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 240,
                  child: TombolGaris(
                    teks: 'Lihat Program 14 Hari',
                    onTap: () =>
                        NavApp.menuWeb.value = 5, // 5 = Program 14 Hari
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Saran edukatif berdasarkan catatanmu, bukan anjuran medis.',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        );
      },
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
                'Berdasarkan target dan riwayatmu',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Rekomendasi Waktu Tidur',
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
        const SizedBox(width: 16),
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

  Widget _kartuWaktu(int tidur) {
    return KartuSomniva(
      warna: AppColors.hijauPastel,
      radius: 30,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Malam ini sebaiknya tidur pukul',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Rekomendasi.jam(tidur),
            style: const TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -2,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Rekomendasi.ringkasan(tidur),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 20),
          PilihJamTidur(
            terpilih: _pilih,
            onPilih: (i) => setState(() => _pilih = i),
          ),
        ],
      ),
    );
  }

  Widget _kartuDasar(int tidur) {
    final windDown = Rekomendasi.windDown(tidur);
    final durasi = Rekomendasi.durasi(tidur);
    final total = Rekomendasi.windDownMenit + durasi;

    final baris = <String>[
      'Target tidur ${DataContoh.targetJam} jam, dihitung mundur dari jam bangun ${Rekomendasi.jam(Rekomendasi.bangunMenit)}',
      Rekomendasi.kalimatRiwayat(),
      StoreTidur.instance.sleepDebtMenit == 0
          ? 'Tidak ada Sleep Debt, pertahankan jadwal tidurmu'
          : '${Rekomendasi.judulDebt()} dicicil bertahap',
    ];

    return KartuSomniva(
      radius: 30,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Dasar rekomendasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < baris.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KotakCentang(
                    centang: _centang[i],
                    onTap: () => setState(() => _centang[i] = !_centang[i]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      baris[i],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 34,
              child: Row(
                children: [
                  Expanded(
                    flex: Rekomendasi.windDownMenit,
                    child: Container(color: AppColors.hijauPastel),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: total - Rekomendasi.windDownMenit,
                    child: Container(color: AppColors.hijauTua),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelBar('${Rekomendasi.jam(windDown)} Wind-down'),
              _labelBar('${Rekomendasi.jam(tidur)} Tidur'),
              _labelBar('${Rekomendasi.jam(Rekomendasi.bangunMenit)} Bangun'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _labelBar(String t) {
    return Text(
      t,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.teksSekunder,
      ),
    );
  }
}
