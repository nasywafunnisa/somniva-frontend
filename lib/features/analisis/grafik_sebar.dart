import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/korelasi.dart';

/// Grafik sebar: jam mulai tidur (sumbu x) dan Sleep Score (sumbu y),
/// dengan garis tren putus-putus.
class GrafikSebar extends StatelessWidget {
  final List<TitikSebar> titik;
  final double tinggi;
  const GrafikSebar({super.key, required this.titik, this.tinggi = 380});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: CustomPaint(
        size: Size.infinite,
        painter: _SebarPainter(titik),
      ),
    );
  }
}

class _SebarPainter extends CustomPainter {
  final List<TitikSebar> titik;
  _SebarPainter(this.titik);

  void _teks(Canvas canvas, String t, Offset p,
      {double ukuran = 14, bool tengah = false, bool kanan = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: ukuran,
          fontWeight: FontWeight.w500,
          color: AppColors.teksSekunder,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = p.dx;
    if (tengah) dx -= tp.width / 2;
    if (kanan) dx -= tp.width;
    tp.paint(canvas, Offset(dx, p.dy - tp.height / 2));
  }

  String _jam(int menit) {
    final m = menit % (24 * 60);
    final h = (m ~/ 60).toString().padLeft(2, '0');
    final mm = (m % 60).toString().padLeft(2, '0');
    return '$h:$mm';
  }

  @override
  void paint(Canvas canvas, Size size) {
    const kiri = 46.0, kanan = 24.0, atas = 14.0, bawah = 40.0;
    final plotW = size.width - kiri - kanan;
    final plotH = size.height - atas - bawah;
    if (plotW <= 0 || plotH <= 0) return;

    // Rentang jam: minimal 22:00 sampai 24:00, melebar kalau ada data di luarnya.
    var xMin = 22 * 60;
    var xMax = 24 * 60;
    for (final p in titik) {
      xMin = math.min(xMin, p.menitTidur);
      xMax = math.max(xMax, p.menitTidur);
    }
    xMin = (xMin ~/ 30) * 30;
    xMax = ((xMax + 29) ~/ 30) * 30;
    if (xMax == xMin) xMax = xMin + 30;

    double x(num menit) => kiri + plotW * (menit - xMin) / (xMax - xMin);
    double y(num skor) {
      final s = skor.clamp(60, 100);
      return atas + plotH * (1 - (s - 60) / 40);
    }

    // Garis bantu dan label sumbu y
    final grid = Paint()
      ..color = const Color(0xFFEFEADC)
      ..strokeWidth = 1.2;
    for (final g in [60, 80, 100]) {
      canvas.drawLine(Offset(kiri, y(g)), Offset(size.width - kanan, y(g)), grid);
      _teks(canvas, '$g', Offset(kiri - 12, y(g)), kanan: true);
    }

    // Label sumbu x tiap 30 menit
    final langkah = (xMax - xMin) > 240 ? 60 : 30;
    for (var m = xMin; m <= xMax; m += langkah) {
      _teks(canvas, _jam(m), Offset(x(m), size.height - bawah + 22),
          tengah: true);
    }

    // Garis tren
    final t = Korelasi.tren(titik);
    if (t != null) {
      final p1 = Offset(x(xMin), y(t.a + t.b * xMin));
      final p2 = Offset(x(xMax), y(t.a + t.b * xMax));
      final garis = Paint()
        ..color = AppColors.hijauTua
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      final panjang = (p2 - p1).distance;
      final arah = (p2 - p1) / panjang;
      var jarak = 0.0;
      while (jarak < panjang) {
        final a = p1 + arah * jarak;
        final b = p1 + arah * math.min(jarak + 10, panjang);
        canvas.drawLine(a, b, garis);
        jarak += 17;
      }
    }

    // Titik-titik
    final isi = Paint()..color = AppColors.hijauSedang.withAlpha(217);
    for (final p in titik) {
      canvas.drawCircle(Offset(x(p.menitTidur), y(p.skor)), 9, isi);
    }
  }

  @override
  bool shouldRepaint(covariant _SebarPainter old) => old.titik != titik;
}
