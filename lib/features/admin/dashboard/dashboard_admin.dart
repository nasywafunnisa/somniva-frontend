import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../core/store_tema.dart';
import '../../../shared/kartu_somniva.dart';

/// Isi Dashboard Admin (desain revisi: Dashboard web admin).
/// Hanya data agregat, tidak ada data pribadi pengguna.
class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final stat = <Widget>[
      _KartuStatAdmin(
        label: 'Total pengguna',
        ikon: Icons.people_outline_rounded,
        nilai: DataAdmin.ribuan(DataAdmin.totalPengguna),
        ket: '+${DataAdmin.ribuan(DataAdmin.penggunaBaruBulanIni)} bulan ini',
      ),
      _KartuStatAdmin(
        label: 'Aktif 7 hari',
        ikon: Icons.monitor_heart_outlined,
        nilai: DataAdmin.ribuan(DataAdmin.aktif7Hari),
        ket: '${DataAdmin.persenAktif}% dari total',
      ),
      _KartuStatAdmin(
        label: 'Artikel terbit',
        ikon: Icons.article_outlined,
        nilai: '${DataAdmin.artikelTerbit}',
        ket: '${DataAdmin.artikelDraf} draf menunggu',
      ),
      _KartuStatAdmin(
        label: 'Peserta program',
        ikon: Icons.check_rounded,
        nilai: DataAdmin.ribuan(DataAdmin.pesertaProgram),
        ket: '${DataAdmin.programTerbanyak} terbanyak',
      ),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 900;

        final grafik = const _KartuPendaftar();
        final program = const _KartuPenyelesaian();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _KepalaDashboard(),
            const SizedBox(height: 24),
            if (sempit) ...[
              _baris([stat[0], stat[1]]),
              const SizedBox(height: 16),
              _baris([stat[2], stat[3]]),
              const SizedBox(height: 20),
              grafik,
              const SizedBox(height: 16),
              program,
            ] else ...[
              _baris(stat),
              const SizedBox(height: 20),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 62, child: grafik),
                    const SizedBox(width: 20),
                    Expanded(flex: 38, child: program),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            const _KartuArtikelPopuler(),
          ],
        );
      },
    );
  }

  static Widget _baris(List<Widget> anak) {
    final isi = <Widget>[];
    for (var i = 0; i < anak.length; i++) {
      if (i > 0) isi.add(const SizedBox(width: 16));
      isi.add(Expanded(child: anak[i]));
    }
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: isi),
    );
  }
}

// =============================================================================
// Kepala
// =============================================================================

class _KepalaDashboard extends StatelessWidget {
  const _KepalaDashboard();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart_rounded,
                      size: 16, color: AppColors.teksSekunder),
                  SizedBox(width: 6),
                  Text(
                    'Ringkasan aplikasi · data agregat',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                'Dashboard Admin',
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
}

// =============================================================================
// Kartu statistik
// =============================================================================

class _KartuStatAdmin extends StatelessWidget {
  final String label;
  final IconData ikon;
  final String nilai;
  final String ket;
  const _KartuStatAdmin({
    required this.label,
    required this.ikon,
    required this.nilai,
    required this.ket,
  });

  @override
  Widget build(BuildContext context) {
    return KartuSomniva(
      radius: 26,
      padding: const EdgeInsets.fromLTRB(24, 22, 22, 22),
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

// =============================================================================
// Pendaftar baru 7 hari
// =============================================================================

class _KartuPendaftar extends StatelessWidget {
  const _KartuPendaftar();

  @override
  Widget build(BuildContext context) {
    final data = DataAdmin.pendaftar7Hari;
    final label = DataAdmin.labelHari7;
    final total = data.reduce((a, b) => a + b);
    final rata = (total / data.length).round();
    var puncak = 0;
    for (var i = 1; i < data.length; i++) {
      if (data[i] > data[puncak]) puncak = i;
    }

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Pendaftar baru 7 hari',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 230,
            child: CustomPaint(
              size: Size.infinite,
              painter: _GrafikPendaftarPainter(data, label),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _KotakRingkas(
                    label: 'Total pendaftar', nilai: '$total'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KotakRingkas(
                    label: 'Rata-rata per hari', nilai: '$rata'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KotakRingkas(
                  label: 'Puncak (${label[puncak]})',
                  nilai: '${data[puncak]}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KotakRingkas extends StatelessWidget {
  final String label;
  final String nilai;
  const _KotakRingkas({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.krim,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrafikPendaftarPainter extends CustomPainter {
  final List<int> nilai;
  final List<String> label;
  _GrafikPendaftarPainter(this.nilai, this.label);

  void _teks(Canvas canvas, String t, Offset titik,
      {bool tengah = false, bool kanan = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.teksSekunder,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = titik.dx;
    if (tengah) dx -= tp.width / 2;
    if (kanan) dx -= tp.width;
    tp.paint(canvas, Offset(dx, titik.dy - tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const kiri = 40.0, kananPad = 14.0, atas = 8.0, bawah = 30.0;
    final plotW = size.width - kiri - kananPad;
    final plotH = size.height - atas - bawah;
    if (plotW <= 0 || plotH <= 0 || nilai.length < 2) return;

    var maks = nilai.reduce((a, b) => a > b ? a : b);
    maks = ((maks + 49) ~/ 50) * 50; // naik ke kelipatan 50
    if (maks < 50) maks = 50;

    double y(num v) => atas + plotH * (1 - v / maks);
    double x(int i) => kiri + plotW * i / (nilai.length - 1);

    // Garis bantu 0, 50, 100, ...
    final garis = Paint()
      ..color = const Color(0xFFEFEADC)
      ..strokeWidth = 1.2;
    for (var g = 0; g <= maks; g += 50) {
      canvas.drawLine(
          Offset(kiri, y(g)), Offset(size.width - kananPad, y(g)), garis);
      _teks(canvas, '$g', Offset(kiri - 10, y(g)), kanan: true);
    }

    // Area lembut di bawah garis
    final area = Path()..moveTo(x(0), y(0));
    for (var i = 0; i < nilai.length; i++) {
      area.lineTo(x(i), y(nilai[i]));
    }
    area
      ..lineTo(x(nilai.length - 1), y(0))
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.hijauSedang.withAlpha(70),
            AppColors.hijauSedang.withAlpha(0),
          ],
        ).createShader(Rect.fromLTWH(kiri, atas, plotW, plotH)),
    );

    // Garis
    final jalur = Path();
    for (var i = 0; i < nilai.length; i++) {
      final p = Offset(x(i), y(nilai[i]));
      if (i == 0) {
        jalur.moveTo(p.dx, p.dy);
      } else {
        jalur.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      jalur,
      Paint()
        ..color = AppColors.hijauSedang
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Titik + label hari
    for (var i = 0; i < nilai.length; i++) {
      final p = Offset(x(i), y(nilai[i]));
      final terakhir = i == nilai.length - 1;
      if (terakhir) {
        canvas.drawCircle(
            p, 14, Paint()..color = AppColors.hijauTua.withAlpha(45));
        canvas.drawCircle(p, 8, Paint()..color = AppColors.hijauTua);
      } else {
        canvas.drawCircle(p, 7, Paint()..color = Colors.white);
        canvas.drawCircle(
          p,
          7,
          Paint()
            ..color = AppColors.hijauSedang
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      if (i < label.length) {
        _teks(canvas, label[i], Offset(p.dx, size.height - bawah + 18),
            tengah: true);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GrafikPendaftarPainter old) =>
      old.nilai != nilai || old.label != label;
}

// =============================================================================
// Penyelesaian Program 14 Hari
// =============================================================================

class _KartuPenyelesaian extends StatelessWidget {
  const _KartuPenyelesaian();

  // Warna per baris: Selesai (hijau tua), Sedang berjalan (hijau sedang),
  // Berhenti (abu hijau).
  static const List<Color> _warna = [
    AppColors.hijauTua,
    AppColors.hijauSedang,
    AppColors.teksSekunder,
  ];

  @override
  Widget build(BuildContext context) {
    final data = DataAdmin.penyelesaian;
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Penyelesaian Program 14 Hari',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const Spacer(),
          for (var i = 0; i < data.length; i++) ...[
            if (i > 0) const SizedBox(height: 22),
            _BarisPenyelesaian(
              label: data[i].label,
              persen: data[i].persen,
              warna: _warna[i % _warna.length],
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

class _BarisPenyelesaian extends StatelessWidget {
  final String label;
  final int persen;
  final Color warna;
  const _BarisPenyelesaian({
    required this.label,
    required this.persen,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ),
            Text(
              '$persen%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: persen / 100,
            minHeight: 9,
            backgroundColor: AppColors.hijauMuda,
            valueColor: AlwaysStoppedAnimation(warna),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Artikel terpopuler
// =============================================================================

class _KartuArtikelPopuler extends StatelessWidget {
  const _KartuArtikelPopuler();

  static IconData _ikon(String kategori) {
    switch (kategori) {
      case 'Kebiasaan':
        return Icons.autorenew_rounded;
      case 'Kafein':
        return Icons.coffee_outlined;
      case 'Kamar':
        return Icons.bed_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DataAdmin.artikelPopuler;
    var maks = 1;
    for (final a in data) {
      if (a.baca > maks) maks = a.baca;
    }

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Artikel terpopuler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < data.length; i++)
            _BarisArtikel(
              nomor: i + 1,
              judul: data[i].judul,
              kategori: data[i].kategori,
              ikon: _ikon(data[i].kategori),
              baca: data[i].baca,
              rasio: data[i].baca / maks,
              garisAtas: true,
            ),
        ],
      ),
    );
  }
}

class _BarisArtikel extends StatelessWidget {
  final int nomor;
  final String judul;
  final String kategori;
  final IconData ikon;
  final int baca;
  final double rasio;
  final bool garisAtas;
  const _BarisArtikel({
    required this.nomor,
    required this.judul,
    required this.kategori,
    required this.ikon,
    required this.baca,
    required this.rasio,
    required this.garisAtas,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final sempit = box.maxWidth < 700;
        final angka = Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.hijauMuda,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$nomor',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
        );
        final judulTeks = Text(
          judul,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.hijauGelap,
          ),
        );
        final chip = Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.krim,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ikon, size: 15, color: AppColors.teksSekunder),
              const SizedBox(width: 6),
              Text(
                kategori,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ],
          ),
        );
        final jumlah = Text(
          '${DataAdmin.ribuan(baca)} baca',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: AppColors.teksSekunder,
          ),
        );
        final batang = ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: rasio.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: AppColors.hijauMuda,
            valueColor: const AlwaysStoppedAnimation(AppColors.hijauSedang),
          ),
        );

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: garisAtas ? const Color(0xFFEFEADC) : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: sempit
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        angka,
                        const SizedBox(width: 14),
                        Expanded(child: judulTeks),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 48),
                        chip,
                        const SizedBox(width: 12),
                        jumlah,
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: batang,
                    ),
                  ],
                )
              : Row(
                  children: [
                    angka,
                    const SizedBox(width: 18),
                    Expanded(flex: 5, child: judulTeks),
                    const SizedBox(width: 16),
                    SizedBox(width: 150, child: Align(
                      alignment: Alignment.centerLeft,
                      child: chip,
                    )),
                    SizedBox(width: 100, child: jumlah),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: batang),
                  ],
                ),
        );
      },
    );
  }
}
