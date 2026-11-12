import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Grafik garis Sleep Score 7 hari (skala 60 sampai 100).
class GrafikSkor extends StatelessWidget {
  final List<int> nilai;
  final List<String> label;
  final double tinggi;

  const GrafikSkor({
    super.key,
    required this.nilai,
    required this.label,
    this.tinggi = 240,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: CustomPaint(
        size: Size.infinite,
        painter: _GrafikPainter(nilai, label),
      ),
    );
  }
}

class _GrafikPainter extends CustomPainter {
  final List<int> nilai;
  final List<String> label;
  _GrafikPainter(this.nilai, this.label);

  void _teks(Canvas canvas, String t, Offset titik,
      {bool tengah = false, bool kanan = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12.5,
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
    const kiri = 44.0, kananPad = 18.0, atas = 10.0, bawah = 32.0;
    final plotW = size.width - kiri - kananPad;
    final plotH = size.height - atas - bawah;
    if (plotW <= 0 || plotH <= 0 || nilai.length < 2) return;

    double yDari(num v) {
      final dibatasi = v.clamp(60, 100);
      return atas + plotH * (1 - (dibatasi - 60) / 40);
    }

    double xDari(int i) => kiri + plotW * i / (nilai.length - 1);

    // Garis bantu
    final garis = Paint()
      ..color = const Color(0xFFEFEADC)
      ..strokeWidth = 1.2;
    for (final g in [60, 80, 100]) {
      final y = yDari(g);
      canvas.drawLine(Offset(kiri, y), Offset(size.width - kananPad, y), garis);
      _teks(canvas, '$g', Offset(kiri - 12, y), kanan: true);
    }

    // Garis skor
    final jalur = Path();
    for (var i = 0; i < nilai.length; i++) {
      final p = Offset(xDari(i), yDari(nilai[i]));
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
        ..strokeWidth = 3.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Titik: putih berbingkai hijau, titik terakhir (hari ini) hijau tua
    for (var i = 0; i < nilai.length; i++) {
      final p = Offset(xDari(i), yDari(nilai[i]));
      final terakhir = i == nilai.length - 1;
      if (terakhir) {
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
  bool shouldRepaint(covariant _GrafikPainter old) =>
      old.nilai != nilai || old.label != label;
}
