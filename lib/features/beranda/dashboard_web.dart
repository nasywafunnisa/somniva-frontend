import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../shared/util.dart';
import '../../core/entri_tidur.dart';
import '../../core/store_tidur.dart';
import '../jurnal/jurnal_web_page.dart';
import 'grafik_skor.dart';

/// Isi Dashboard untuk tampilan WEB (desain: Website UI 03).
class DashboardWeb extends StatelessWidget {
  /// Pindah ke menu sidebar nomor [i] (dipakai setelah jurnal disimpan).
  final void Function(int i) onPindah;
  const DashboardWeb({super.key, required this.onPindah});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreTidur.instance,
      builder: (context, _) => _isi(context),
    );
  }

  Widget _isi(BuildContext context) {
    final sekarang = DateTime.now();
    final e = StoreTidur.instance.entri;
    final skor = StoreTidur.instance.skor;
    final naik = skor - DataContoh.skorKemarin;
    final selisih = naik >= 0 ? 'naik $naik poin' : 'turun ${-naik} poin';

    final statistik = <Widget>[
      _KartuStat(
        label: 'Sleep Score semalam',
        nilai: '$skor',
        ket: '${FormatTanggal.labelSkor(skor)} · $selisih',
      ),
      _KartuStat(
        label: 'Durasi tidur',
        nilai: e.durasiTeks,
        ket: e.rentangTeks,
      ),
      _KartuStat(
        label: 'Sleep Debt',
        nilai: EntriTidur.formatDurasi(StoreTidur.instance.sleepDebtMenit),
        ket: DataContoh.sleepDebtKet,
      ),
      const _KartuStat(
        label: 'Konsistensi jadwal',
        nilai: '${DataContoh.konsistensi}%',
        ket: DataContoh.konsistensiKet,
      ),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;

        final grafik = KartuSomniva(
          radius: 28,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sleep Score 7 hari',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.hijauTua,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '7 hari',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GrafikSkor(
                nilai: DataContoh.skorMingguan,
                label: FormatTanggal.tujuhHariTerakhir(sekarang),
              ),
            ],
          ),
        );

        final kartuIdeal = KartuSomniva(
          warna: AppColors.hijauPastel,
          radius: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tidur ideal malam ini',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                DataContoh.tidurIdeal,
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Bangun ${DataContoh.bangunIdeal} · target ${DataContoh.targetJam} jam',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 18),
              TombolUtama(
                teks: 'Lihat rekomendasi',
                onTap: () => tampilkanSegera(context, 'Rekomendasi Tidur'),
              ),
            ],
          ),
        );

        final kartuProgram = KartuSomniva(
          radius: 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
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
                    'Hari ${DataContoh.programHari}',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: DataContoh.programHari / DataContoh.programTotal,
                  minHeight: 8,
                  backgroundColor: AppColors.hijauMuda,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.hijauSedang),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Hari ini: ${DataContoh.programHariIni}',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        );

        final temuan = KartuSomniva(
          warna: AppColors.krim,
          radius: 28,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: sempit
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _judulTemuan(),
                    const SizedBox(height: 8),
                    _isiTemuan(),
                    const SizedBox(height: 16),
                    _tombolKorelasi(context),
                  ],
                )
              : Row(
                  children: [
                    _judulTemuan(),
                    const SizedBox(width: 20),
                    Expanded(child: _isiTemuan()),
                    const SizedBox(width: 20),
                    _tombolKorelasi(context),
                  ],
                ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _kepala(context, sekarang),
            const SizedBox(height: 24),
            if (sempit) ...[
              _baris([statistik[0], statistik[1]]),
              const SizedBox(height: 16),
              _baris([statistik[2], statistik[3]]),
              const SizedBox(height: 20),
              grafik,
              const SizedBox(height: 16),
              kartuIdeal,
              const SizedBox(height: 16),
              kartuProgram,
            ] else ...[
              _baris(statistik),
              const SizedBox(height: 20),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 62, child: grafik),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 38,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          kartuIdeal,
                          const SizedBox(height: 16),
                          Expanded(child: kartuProgram),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            temuan,
          ],
        );
      },
    );
  }

  Widget _kepala(BuildContext context, DateTime sekarang) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FormatTanggal.panjang(sekarang),
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
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final disimpan = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const JurnalWebPage()),
              );
              if (disimpan == true) onPindah(1); // 1 = Score & Debt
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.hijauTua,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 26),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Catat tidur hari ini',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: AppColors.krim,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => tampilkanSegera(context, 'Mode gelap'),
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

  Widget _baris(List<Widget> anak) {
    final isi = <Widget>[];
    for (var i = 0; i < anak.length; i++) {
      if (i > 0) isi.add(const SizedBox(width: 16));
      isi.add(Expanded(child: anak[i]));
    }
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: isi),
    );
  }

  Widget _judulTemuan() => const Text(
        'Temuan minggu ini',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.hijauGelap,
        ),
      );

  Widget _isiTemuan() => const Text(
        DataContoh.temuan,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          height: 1.45,
          color: AppColors.hijauGelap,
        ),
      );

  Widget _tombolKorelasi(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () => tampilkanSegera(context, 'Pola & Korelasi'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hijauGelap,
          side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
          padding: const EdgeInsets.symmetric(horizontal: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Lihat korelasi',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _KartuStat extends StatelessWidget {
  final String label;
  final String nilai;
  final String ket;
  const _KartuStat({
    required this.label,
    required this.nilai,
    required this.ket,
  });

  @override
  Widget build(BuildContext context) {
    return KartuSomniva(
      radius: 26,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      child: Column(
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
          const SizedBox(height: 6),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ket,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}
