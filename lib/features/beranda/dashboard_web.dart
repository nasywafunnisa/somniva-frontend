import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/store_tema.dart';
import '../../core/app_colors.dart';
import '../../core/data_contoh.dart';
import '../../core/format_tanggal.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/logo_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../../core/entri_tidur.dart';
import '../../core/korelasi.dart';
import '../../core/store_program.dart';
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
      listenable:
          Listenable.merge([StoreTidur.instance, StoreProgram.instance]),
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
        ikon: Icons.dark_mode_outlined,
        nilai: '$skor',
        ket: '${FormatTanggal.labelSkor(skor)} · $selisih',
      ),
      _KartuStat(
        label: 'Durasi tidur',
        ikon: Icons.schedule_rounded,
        nilai: e.durasiTeks,
        ket: e.rentangTeks,
      ),
      _KartuStat(
        label: 'Sleep Debt',
        ikon: Icons.calendar_today_outlined,
        nilai: EntriTidur.formatDurasi(StoreTidur.instance.sleepDebtMenit),
        ket: DataContoh.sleepDebtKet,
      ),
      const _KartuStat(
        label: 'Konsistensi jadwal',
        ikon: Icons.show_chart_rounded,
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
          child: Stack(
            children: [
              const Positioned(
                right: -4,
                top: -8,
                width: 120,
                height: 120,
                child: CustomPaint(painter: _HiasanBulan()),
              ),
              Column(
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
                  Text(
                    DataContoh.tidurIdeal,
                    style: const TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bangun ${DataContoh.bangunIdeal} · target ${DataContoh.targetJam} jam',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TombolUtama(
                    teks: 'Lihat rekomendasi',
                    onTap: () => onPindah(4), // 4 = Rekomendasi Tidur
                  ),
                ],
              ),
            ],
          ),
        );

        final kartuProgramIsi = KartuSomniva(
          radius: 28,
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
                    'Hari ${StoreProgram.instance.hariAktif}',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _BatangProgram(
                hari: StoreProgram.instance.hariAktif,
                total: StoreProgram.total,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.hijauMuda,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 17, color: AppColors.hijauTua),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hari ini: ${StoreProgram.instance.judulHariIni.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        // Kartu program bisa diketuk untuk membuka halaman Program 14 Hari.
        final kartuProgram = MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onPindah(5),
            child: kartuProgramIsi,
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
                    Row(
                      children: [
                        _ikonTemuan(),
                        const SizedBox(width: 14),
                        _judulTemuan(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _isiTemuan(),
                    const SizedBox(height: 12),
                    _bandingTemuan(),
                    const SizedBox(height: 16),
                    _tombolKorelasi(context),
                  ],
                )
              : Row(
                  children: [
                    _ikonTemuan(),
                    const SizedBox(width: 18),
                    _judulTemuan(),
                    const SizedBox(width: 20),
                    Expanded(child: _isiTemuan()),
                    const SizedBox(width: 20),
                    _bandingTemuan(),
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
              Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined,
                      size: 16, color: AppColors.hijauSedang),
                  const SizedBox(width: 6),
                  Text(
                    FormatTanggal.panjang(sekarang),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
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
              elevation: 6,
              shadowColor: const Color(0x552F3A2B),
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
          color: AppColors.hijauPastel,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: StoreTema.instance.balik,
            child: const SizedBox(
              width: 50,
              height: 50,
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

  Widget _ikonTemuan() => Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.hijauPastel,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.lightbulb_outline_rounded,
            size: 26, color: AppColors.hijauTua),
      );

  /// Dua batang kecil: skor rata-rata sebelum vs setelah 15:00 (kafein).
  /// Hanya tampil kalau catatan sudah cukup untuk dibandingkan.
  Widget _bandingTemuan() {
    final k = Korelasi.kafein(StoreTidur.instance.riwayat);
    if (!k.cukup) return const SizedBox.shrink();
    Widget baris(int v, Color warna) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80 * v / 100,
              height: 7,
              decoration: BoxDecoration(
                color: warna,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$v',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        baris(k.nilai1!, AppColors.hijauSedang),
        const SizedBox(height: 8),
        baris(k.nilai2!, AppColors.hijauTua),
      ],
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

  Widget _isiTemuan() => Text(
        Korelasi.temuan(StoreTidur.instance.riwayat),
        style: const TextStyle(
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
        onPressed: () => onPindah(2), // 2 = Pola & Korelasi
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
  final IconData ikon;
  const _KartuStat({
    required this.ikon,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.hijauMuda,
                  shape: BoxShape.circle,
                ),
                child: Icon(ikon, size: 19, color: AppColors.hijauTua),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 40,
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

/// Batang program: satu potongan per hari, terisi sampai hari aktif.
class _BatangProgram extends StatelessWidget {
  final int hari;
  final int total;
  const _BatangProgram({required this.hari, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: i < hari ? AppColors.hijauTua : AppColors.hijauMuda,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Hiasan di kartu "Tidur ideal": lingkaran lembut, bulan sabit, dan kilau.
class _HiasanBulan extends CustomPainter {
  const _HiasanBulan();

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = Offset(size.width * 0.55, size.height * 0.52);
    canvas.drawCircle(
      pusat,
      size.width * 0.46,
      Paint()..color = AppColors.hijauMuda.withAlpha(170),
    );
    canvas.drawPath(
      bulanSabit(pusat, size.width * 0.27),
      Paint()..color = AppColors.hijauSedang.withAlpha(120),
    );
    void kilau(Offset p, double r) {
      final path = Path();
      for (var i = 0; i < 8; i++) {
        final a = -3.14159265 / 2 + i * 3.14159265 / 4;
        final jr = i.isEven ? r : r * 0.3;
        final t = p + Offset(_cos(a), _sin(a)) * jr;
        if (i == 0) {
          path.moveTo(t.dx, t.dy);
        } else {
          path.lineTo(t.dx, t.dy);
        }
      }
      path.close();
      canvas.drawPath(
          path, Paint()..color = AppColors.hijauSedang.withAlpha(150));
    }

    kilau(Offset(size.width * 0.12, size.height * 0.12), 5);
    kilau(Offset(size.width * 0.9, size.height * 0.9), 4);
  }

  static double _cos(double a) => math.cos(a);
  static double _sin(double a) => math.sin(a);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
