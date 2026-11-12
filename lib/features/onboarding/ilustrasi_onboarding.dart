import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Kartu hijau pastel berisi ilustrasi. [halaman] 0, 1, atau 2.
class IlustrasiOnboarding extends StatelessWidget {
  final int halaman;
  const IlustrasiOnboarding({super.key, required this.halaman});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.hijauPastel,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CustomPaint(
          painter: _IlustrasiPainter(halaman),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _IlustrasiPainter extends CustomPainter {
  final int halaman;
  _IlustrasiPainter(this.halaman);

  @override
  void paint(Canvas canvas, Size size) {
    final u = math.min(size.width, size.height); // satuan ukuran
    final c = Offset(size.width / 2, size.height / 2);

    // Lingkaran krim di tengah
    canvas.drawCircle(c, u * 0.27, Paint()..color = AppColors.krim);

    switch (halaman) {
      case 0:
        _halaman1(canvas, c, u);
        break;
      case 1:
        _halaman2(canvas, c, u);
        break;
      default:
        _halaman3(canvas, c, u);
    }
  }

  // Halaman 1: gelombang pola tidur + bulan kecil
  void _halaman1(Canvas canvas, Offset c, double u) {
    Offset p(double x, double y) => Offset(c.dx + x * u, c.dy + y * u);

    final gelombang = Path()
      ..moveTo(p(-0.38, 0.19).dx, p(-0.38, 0.19).dy)
      ..cubicTo(p(-0.30, 0.08).dx, p(-0.30, 0.08).dy, p(-0.18, 0.12).dx,
          p(-0.18, 0.12).dy, p(-0.08, 0.14).dx, p(-0.08, 0.14).dy)
      ..cubicTo(p(0.05, 0.17).dx, p(0.05, 0.17).dy, p(0.10, -0.03).dx,
          p(0.10, -0.03).dy, p(0.18, -0.035).dx, p(0.18, -0.035).dy)
      ..cubicTo(p(0.26, -0.04).dx, p(0.26, -0.04).dy, p(0.33, 0.02).dx,
          p(0.33, 0.02).dy, p(0.38, 0.065).dx, p(0.38, 0.065).dy);
    canvas.drawPath(
      gelombang,
      Paint()
        ..color = AppColors.hijauSedang
        ..style = PaintingStyle.stroke
        ..strokeWidth = u * 0.022
        ..strokeCap = StrokeCap.round,
    );

    _bulanKecil(canvas, p(0.17, -0.14), u);
    final titik = Paint()..color = AppColors.hijauSedang;
    canvas.drawCircle(p(-0.17, -0.12), u * 0.014, titik);
    canvas.drawCircle(p(-0.24, 0.0), u * 0.010, titik);
  }

  // Halaman 2: cincin skor 82
  void _halaman2(Canvas canvas, Offset c, double u) {
    final r = u * 0.185;
    final lebar = u * 0.045;
    final rect = Rect.fromCircle(center: c, radius: r);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = AppColors.hijauPastel
        ..style = PaintingStyle.stroke
        ..strokeWidth = lebar,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * 0.82,
      false,
      Paint()
        ..color = AppColors.hijauSedang
        ..style = PaintingStyle.stroke
        ..strokeWidth = lebar
        ..strokeCap = StrokeCap.round,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: '82',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w800,
          fontSize: u * 0.15,
          color: AppColors.hijauGelap,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));

    _bulanKecil(canvas, Offset(c.dx + u * 0.20, c.dy - u * 0.17), u);
    final titik = Paint()..color = AppColors.hijauSedang;
    canvas.drawCircle(Offset(c.dx - u * 0.22, c.dy - u * 0.16), u * 0.014, titik);
    canvas.drawCircle(Offset(c.dx + u * 0.24, c.dy + u * 0.17), u * 0.010, titik);
  }

  // Halaman 3: 14 titik program, 5 sudah terisi
  void _halaman3(Canvas canvas, Offset c, double u) {
    final jarak = u * 0.062;
    final radius = u * 0.021;
    final aktif = Paint()..color = AppColors.hijauTua;
    final mati = Paint()..color = AppColors.titikMati;

    for (var baris = 0; baris < 2; baris++) {
      for (var kolom = 0; kolom < 7; kolom++) {
        final indeks = baris * 7 + kolom;
        final x = c.dx + (kolom - 3) * jarak;
        final y = c.dy + (baris == 0 ? 0.02 : 0.10) * u;
        canvas.drawCircle(Offset(x, y), radius, indeks < 5 ? aktif : mati);
      }
    }

    // Bulan sabit di atas titik
    _sabit(canvas, Offset(c.dx, c.dy - u * 0.10), u * 0.07, AppColors.hijauSedang);

    _bulanKecil(canvas, Offset(c.dx + u * 0.20, c.dy - u * 0.17), u);
    final titik = Paint()..color = AppColors.hijauSedang;
    canvas.drawCircle(Offset(c.dx - u * 0.22, c.dy - u * 0.14), u * 0.014, titik);
    canvas.drawCircle(Offset(c.dx - u * 0.25, c.dy + u * 0.02), u * 0.010, titik);
  }

  // Bulan gelap dengan lingkaran krim di sisi kanan atasnya (seperti desain)
  void _bulanKecil(Canvas canvas, Offset pusat, double u) {
    canvas.drawCircle(pusat, u * 0.067, Paint()..color = AppColors.hijauTua);
    canvas.drawCircle(
      pusat.translate(u * 0.027, -u * 0.012),
      u * 0.058,
      Paint()..color = AppColors.krim,
    );
  }

  void _sabit(Canvas canvas, Offset pusat, double r, Color warna) {
    final besar = Path()..addOval(Rect.fromCircle(center: pusat, radius: r));
    final potong = Path()
      ..addOval(Rect.fromCircle(
        center: pusat.translate(r * 0.42, -r * 0.26),
        radius: r * 0.8,
      ));
    canvas.drawPath(
      Path.combine(PathOperation.difference, besar, potong),
      Paint()..color = warna,
    );
  }

  @override
  bool shouldRepaint(covariant _IlustrasiPainter old) => old.halaman != halaman;
}
