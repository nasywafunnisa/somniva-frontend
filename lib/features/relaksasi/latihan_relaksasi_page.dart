import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/latihan_relaksasi.dart';
import '../../core/store_winddown.dart';
import '../../shared/kartu_somniva.dart';
import 'lingkaran_napas.dart';

/// Latihan Relaksasi untuk HP (desain: Mobile App UI 15).
/// Dibuka dari Wind-Down Routine ("Mulai latihan napas") atau dari Beranda.
/// Lingkaran bergerak mengikuti fase: tarik, tahan, buang.
class LatihanRelaksasiPage extends StatefulWidget {
  /// Nomor latihan di LatihanRelaksasi.daftar yang langsung dimulai.
  final int awal;

  const LatihanRelaksasiPage({super.key, this.awal = 0});

  @override
  State<LatihanRelaksasiPage> createState() => _LatihanRelaksasiPageState();
}

class _LatihanRelaksasiPageState extends State<LatihanRelaksasiPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late LatihanRelaksasi _aktif;

  @override
  void initState() {
    super.initState();
    _aktif = LatihanRelaksasi.daftar[widget.awal];
    _c = AnimationController(
      vsync: this,
      duration: Duration(seconds: _aktif.totalDetik),
    );
    _c.addListener(() {
      if (mounted) setState(() {});
    });
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _selesai(tutup: false);
      }
    });
    _c.forward(); // langsung mulai
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  // Detik yang sudah berjalan.
  double get _berjalan => _c.value * _aktif.totalDetik;

  void _mulaiLatihan(LatihanRelaksasi l) {
    setState(() => _aktif = l);
    _c.duration = Duration(seconds: l.totalDetik);
    _c.reset();
    _c.forward();
  }

  void _jedaAtauLanjut() {
    if (_c.isCompleted) {
      _c.reset();
      _c.forward();
    } else if (_c.isAnimating) {
      _c.stop();
    } else {
      _c.forward();
    }
    setState(() {});
  }

  void _ulang() {
    _c.reset();
    _c.forward();
  }

  void _selesai({required bool tutup}) {
    _c.stop();
    String pesan = 'Latihan selesai. Semoga lebih tenang.';
    if (_aktif.napas478) {
      StoreWindDown.instance.tandaiSelesai(3); // langkah "Latihan napas 4–7–8"
      pesan = 'Latihan selesai. Langkah napas di Wind-Down Routine ditandai.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(pesan)),
    );
    if (tutup) Navigator.of(context).pop();
  }

  String _mmss(double detik) {
    final d = detik.floor();
    final m = (d ~/ 60).toString().padLeft(2, '0');
    final s = (d % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Fase yang sedang berjalan, detik di dalam fase itu, dan ukuran lingkaran (0..1).
  ({FaseLatihan fase, double detikDiFase, double ukuran}) get _keadaan {
    final siklus = _aktif.panjangSiklus;
    var t = _berjalan % siklus;
    for (final f in _aktif.fase) {
      if (t < f.detik) {
        final p = Curves.easeInOut.transform(t / f.detik);
        final u = switch (f.gerak) {
          Gerak.naik => p,
          Gerak.besar => 1.0,
          Gerak.turun => 1 - p,
          Gerak.kecil => 0.0,
        };
        return (fase: f, detikDiFase: t, ukuran: u);
      }
      t -= f.detik;
    }
    return (fase: _aktif.fase.last, detikDiFase: 0, ukuran: 0);
  }

  @override
  Widget build(BuildContext context) {
    final lain = [
      for (final l in LatihanRelaksasi.daftar)
        if (l != _aktif) l,
    ];

    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _kepala(),
                  const SizedBox(height: 18),
                  _kartuLatihan(),
                  const SizedBox(height: 16),
                  _barisWaktu(),
                  const SizedBox(height: 18),
                  _kontrol(),
                  const SizedBox(height: 22),
                  const Text(
                    'Latihan lain',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final l in lain) _kartuLain(l),
                  const SizedBox(height: 4),
                  const Text(
                    'Latihan ini membantu rileks, bukan pengganti saran tenaga medis.',
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
          ),
        ),
      ),
    );
  }

  Widget _kepala() {
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
            'Latihan Relaksasi',
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

  Widget _kartuLatihan() {
    final k = _keadaan;
    final selesai = _c.isCompleted;
    return KartuSomniva(
      warna: AppColors.hijauPastel,
      radius: 32,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        children: [
          LingkaranNapas(
            ukuran: k.ukuran,
            label: selesai ? 'Selesai' : k.fase.label,
            angka: selesai ? null : k.detikDiFase.floor() + 1,
          ),
          const SizedBox(height: 14),
          Text(
            _aktif.nama,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _barisWaktu() {
    const gaya = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.teksSekunder,
    );
    return Row(
      children: [
        Text(_mmss(_berjalan), style: gaya),
        const SizedBox(width: 14),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 10,
              color: AppColors.hijauMuda,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: _c.value.clamp(0.0, 1.0),
                heightFactor: 1,
                child: Container(color: AppColors.hijauSedang),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(_mmss(_aktif.totalDetik.toDouble()), style: gaya),
      ],
    );
  }

  Widget _kontrol() {
    final jalan = _c.isAnimating;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tombolKotak(Icons.replay_rounded, _ulang),
        const SizedBox(width: 24),
        Material(
          color: AppColors.hijauTua,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _jedaAtauLanjut,
            child: SizedBox(
              width: 64,
              height: 64,
              child: Icon(
                jalan ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 34,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        _tombolKotak(Icons.check_rounded, () => _selesai(tutup: true)),
      ],
    );
  }

  Widget _tombolKotak(IconData ikon, VoidCallback onTap) {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(ikon, size: 24, color: AppColors.hijauGelap),
        ),
      ),
    );
  }

  Widget _kartuLain(LatihanRelaksasi l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: KartuSomniva(
        radius: 26,
        padding: const EdgeInsets.fromLTRB(22, 14, 16, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.nama,
                    style: const TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  Text(
                    l.ket,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color: AppColors.krim,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _mulaiLatihan(l),
                child: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 26,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
