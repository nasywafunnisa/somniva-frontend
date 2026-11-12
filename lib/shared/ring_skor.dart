import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Cincin skor dengan angka di tengah (0 sampai 100).
class RingSkor extends StatelessWidget {
  final int nilai;
  final double ukuran;
  final double tebal;

  const RingSkor({
    super.key,
    required this.nilai,
    this.ukuran = 108,
    this.tebal = 13,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(
        painter: _RingPainter(nilai / 100, tebal),
        child: Center(
          child: Text(
            '$nilai',
            style: TextStyle(
              fontSize: ukuran * 0.36,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double bagian;
  final double tebal;
  _RingPainter(this.bagian, this.tebal);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.width - tebal) / 2,
    );
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = AppColors.hijauPastel
        ..style = PaintingStyle.stroke
        ..strokeWidth = tebal,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * bagian,
      false,
      Paint()
        ..color = AppColors.hijauSedang
        ..style = PaintingStyle.stroke
        ..strokeWidth = tebal
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.bagian != bagian || old.tebal != tebal;
}
