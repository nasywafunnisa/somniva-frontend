import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

/// Grafik garis sederhana untuk Dashboard Admin (mulai dari 0).
/// Garis bantu di kelipatan 50, titik terakhir (hari ini) hijau tua.
class GrafikGarisAdmin extends StatelessWidget {
  final List<int> nilai;
  final List<String> label;
  final double tinggi;

  const GrafikGarisAdmin({
    super.key,
    required this.nilai,
    required this.label,
    this.tinggi = 230,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: CustomPaint(
        size: Size.infinite,
        painter: _GrafikAdminPainter(nilai, label),
      ),
    );
  }
}

class _GrafikAdminPainter extends CustomPainter {
  final List<int> nilai;
  final List<String> label;
  _GrafikAdminPainter(this.nilai, this.label);

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

    var terbesar = 0;
    for (final n in nilai) {
      if (n > terbesar) terbesar = n;
    }
    // Batas atas = kelipatan 50 di atas nilai terbesar (minimal 50).
    final puncak = ((terbesar / 50).ceil() * 50).clamp(50, 100000).toDouble();

    double yDari(num v) => atas + plotH * (1 - v / puncak);
    double xDari(int i) => kiri + plotW * i / (nilai.length - 1);

    // Garis bantu: 0, 50, 100, ... selama tidak melewati nilai terbesar.
    final garis = Paint()
      ..color = const Color(0xFFEFEADC)
      ..strokeWidth = 1.2;
    for (var g = 0; g <= terbesar; g += 50) {
      final y = yDari(g);
      canvas.drawLine(Offset(kiri, y), Offset(size.width - kananPad, y), garis);
      _teks(canvas, '$g', Offset(kiri - 12, y), kanan: true);
    }

    // Garis data
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

    // Titik terakhir (hari ini) saja, seperti di desain
    final akhir = Offset(xDari(nilai.length - 1), yDari(nilai.last));
    canvas.drawCircle(akhir, 8, Paint()..color = AppColors.hijauTua);

    // Nama hari
    for (var i = 0; i < nilai.length; i++) {
      if (i < label.length) {
        _teks(canvas, label[i], Offset(xDari(i), size.height - bawah + 18),
            tengah: true);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GrafikAdminPainter old) =>
      old.nilai != nilai || old.label != label;
}
