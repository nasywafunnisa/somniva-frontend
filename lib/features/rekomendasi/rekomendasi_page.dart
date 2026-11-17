import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../pengingat/aksi_pengingat.dart';
import '../pengingat/wind_down_page.dart';
import 'bagian_rekomendasi.dart';

/// Rekomendasi Waktu Tidur untuk HP (desain: Mobile App UI 11).
/// Dibuka dengan mengetuk kartu "Tidur ideal malam ini" di Beranda.
class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  int _pilih = 1;
  final List<bool> _centang = [false, false, false];

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
    final tidur = Rekomendasi.pilihan[_pilih];
    final windDown = Rekomendasi.windDown(tidur);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _kepala(context),
                const SizedBox(height: 18),
                _kartuWaktu(tidur),
                const SizedBox(height: 16),
                PilihJamTidur(
                  kecil: true,
                  terpilih: _pilih,
                  onPilih: (i) => setState(() => _pilih = i),
                ),
                const SizedBox(height: 16),
                _kartuDasar(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
          child: Column(
            children: [
              TombolUtama(
                teks: 'Aktifkan pengingat ${Rekomendasi.jam(windDown)}',
                onTap: () => aktifkanPengingatDariRekomendasi(
                  context,
                  tidur,
                  denganTombolAtur: true,
                ),
              ),
              const SizedBox(height: 12),
              TombolGaris(
                teks: 'Lihat Wind-Down Routine',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WindDownPage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Saran edukatif berdasarkan catatanmu, bukan anjuran medis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
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
        const Expanded(
          child: Text(
            'Rekomendasi Waktu Tidur',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
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
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Malam ini sebaiknya tidur pukul',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            Rekomendasi.jam(tidur),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 84,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -2,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Rekomendasi.ringkasan(tidur),
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: AppColors.hijauGelap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuDasar() {
    final isi = <(String, String)>[
      (
        'Target tidur ${DataContoh.targetJam} jam',
        'Dihitung mundur dari jam bangun ${Rekomendasi.jam(Rekomendasi.bangunMenit)}',
      ),
      ('Riwayatmu', Rekomendasi.kalimatRiwayat()),
      (Rekomendasi.judulDebt(), Rekomendasi.ketDebt()),
    ];

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 10),
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
          const SizedBox(height: 14),
          for (var i = 0; i < isi.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KotakCentang(
                    ukuran: 36,
                    centang: _centang[i],
                    onTap: () => setState(() => _centang[i] = !_centang[i]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isi[i].$1,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        Text(
                          isi[i].$2,
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
            ),
        ],
      ),
    );
  }
}
