import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Grafik batang durasi tidur 7 hari dengan garis target.
/// Batang hijau = mencapai target, cokelat = di bawah target.
class GrafikDurasi extends StatelessWidget {
  final List<int> menit;
  final List<String> label;
  final int targetJam;
  final double tinggi;

  const GrafikDurasi({
    super.key,
    required this.menit,
    required this.label,
    required this.targetJam,
    this.tinggi = 290,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DurasiPainter(menit, label, targetJam),
      ),
    );
  }
}

class _DurasiPainter extends CustomPainter {
  final List<int> menit;
  final List<String> label;
  final int targetJam;
  _DurasiPainter(this.menit, this.label, this.targetJam);

  void _teks(Canvas canvas, String t, Offset titik,
      {double ukuran = 13,
      FontWeight berat = FontWeight.w500,
      Color warna = AppColors.teksSekunder,
      bool tengah = true,
      bool kanan = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: ukuran,
          fontWeight: berat,
          color: warna,
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
    if (menit.isEmpty) return;
    const atas = 26.0, bawah = 30.0;
    final plotH = size.height - atas - bawah;
    final dasar = atas + plotH;
    if (plotH <= 0 || size.width <= 0) return;

    final terbesar = menit.reduce((a, b) => a > b ? a : b) / 60.0;
    final skalaMax = (terbesar > 9 ? terbesar : 9.0) + 0.3;
    double yDari(double jam) => dasar - plotH * (jam / skalaMax);

    final slot = size.width / menit.length;
    final lebarBatang = slot * 0.62;

    // Batang
    for (var i = 0; i < menit.length; i++) {
      final jam = menit[i] / 60.0;
      final cx = slot * i + slot / 2;
      final y = yDari(jam);
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTRB(cx - lebarBatang / 2, y, cx + lebarBatang / 2, dasar),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: const Radius.circular(6),
        bottomRight: const Radius.circular(6),
      );
      final capai = menit[i] >= targetJam * 60;
      canvas.drawRRect(
        rect,
        Paint()..color = capai ? AppColors.hijauSedang : AppColors.cokelat,
      );
      _teks(canvas, jam.toStringAsFixed(1), Offset(cx, y - 12),
          ukuran: 13.5, berat: FontWeight.w800, warna: AppColors.hijauGelap);
      if (i < label.length) {
        _teks(canvas, label[i], Offset(cx, size.height - bawah + 16));
      }
    }

    // Garis target putus-putus
    final yt = yDari(targetJam.toDouble());
    final garis = Paint()
      ..color = AppColors.hijauSedang
      ..strokeWidth = 1.3;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, yt), Offset((x + 5).clamp(0, size.width), yt), garis);
      x += 9;
    }
    _teks(canvas, 'Target ${targetJam}j', Offset(size.width, yt - 16),
        ukuran: 12.5, tengah: false, kanan: true);
  }

  @override
  bool shouldRepaint(covariant _DurasiPainter old) =>
      old.menit != menit || old.label != label || old.targetJam != targetJam;
}
