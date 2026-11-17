import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/rekomendasi.dart';
import '../../core/store_pengingat.dart';
import '../../core/store_winddown.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../rekomendasi/bagian_rekomendasi.dart';
import '../relaksasi/latihan_relaksasi_page.dart';
import 'pengingat_page.dart';

/// Wind-Down Routine untuk HP (desain: Mobile App UI 13).
/// Dibuka dari Rekomendasi ("Lihat Wind-Down Routine") atau dari Beranda.
class WindDownPage extends StatelessWidget {
  const WindDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListenableBuilder(
              listenable: Listenable.merge([
                StoreWindDown.instance,
                StorePengingat.instance,
              ]),
              builder: (context, _) => _isi(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _isi(BuildContext context) {
    final store = StoreWindDown.instance;
    final mulai = Rekomendasi.jam(StorePengingat.instance.windDownMenit);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _kepala(context, mulai),
                const SizedBox(height: 18),
                _kartuProgres(store),
                const SizedBox(height: 14),
                _kartuDaftar(store),
                const SizedBox(height: 14),
                const KartuSomniva(
                  warna: AppColors.hijauPastel,
                  radius: 26,
                  padding: EdgeInsets.fromLTRB(22, 22, 22, 22),
                  child: Text(
                    'Rutinitas yang sama setiap malam membantu tubuh mengenali waktu tidur.',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
          child: Column(
            children: [
              TombolUtama(
                teks: 'Mulai latihan napas',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LatihanRelaksasiPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TombolGaris(
                teks: 'Atur pengingat wind-down',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PengingatPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kepala(BuildContext context, String mulai) {
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wind-Down Routine',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                'Mulai $mulai · sekitar ${Rekomendasi.windDownMenit} menit',
                style: const TextStyle(
                  fontSize: 13.5,
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

  Widget _kartuProgres(StoreWindDown store) {
    return KartuSomniva(
      warna: AppColors.krim,
      radius: 26,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${store.jumlah} dari ${store.total} selesai',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              Text(
                '${store.persen}%',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 12,
              color: AppColors.hijauMuda,
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.centerLeft,
                widthFactor: store.jumlah / store.total,
                heightFactor: 1,
                child: Container(color: AppColors.hijauSedang),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuDaftar(StoreWindDown store) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 10),
      child: Column(
        children: [
          for (var i = 0; i < StoreWindDown.langkah.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  KotakCentang(
                    ukuran: 36,
                    centang: store.selesai(i),
                    onTap: () => store.ubah(i),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StoreWindDown.langkah[i].judul,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        Text(
                          StoreWindDown.langkah[i].ket,
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
