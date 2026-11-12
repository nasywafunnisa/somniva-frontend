import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/logo_somniva.dart';

/// Gelombang dan bulan di bagian bawah panel kiri (tampilan web).
class IlustrasiGelombang extends StatelessWidget {
  const IlustrasiGelombang({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GelombangPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GelombangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    Offset p(double x, double y) => Offset(x * w, y * h);

    final a = p(0, 0.93);
    final path = Path()..moveTo(a.dx, a.dy);
    void kurva(Offset c1, Offset c2, Offset akhir) =>
        path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, akhir.dx, akhir.dy);

    kurva(p(0.08, 0.70), p(0.18, 0.80), p(0.27, 0.82));
    kurva(p(0.40, 0.80), p(0.45, 0.10), p(0.58, 0.10));
    kurva(p(0.70, 0.10), p(0.74, 0.72), p(0.83, 0.68));
    kurva(p(0.90, 0.66), p(0.95, 0.24), p(1.0, 0.14));

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.hijauSedang
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Bulan sabit gelap di dekat ujung kanan
    canvas.drawPath(
      bulanSabit(p(0.82, 0.12), w * 0.055),
      Paint()..color = AppColors.hijauTua,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
