import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

/// Grafik garis Sleep Score untuk HP (7, 30, atau 90 hari).
/// Tanpa angka di sisi kiri, hanya tiga garis bantu, seperti di desain.
class GrafikGarisRiwayat extends StatelessWidget {
  final List<int> nilai;
  final List<String> label; // boleh berisi '' untuk titik tanpa label
  final double tinggi;

  const GrafikGarisRiwayat({
    super.key,
    required this.nilai,
    required this.label,
    this.tinggi = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: CustomPaint(
        size: Size.infinite,
        painter: _GarisPainter(nilai, label),
      ),
    );
  }
}

class _GarisPainter extends CustomPainter {
  final List<int> nilai;
  final List<String> label;
  _GarisPainter(this.nilai, this.label);

  void _teks(Canvas canvas, String t, double xTengah, double yAtas,
      double lebarMax) {
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
    var x = xTengah - tp.width / 2;
    if (x + tp.width > lebarMax) x = lebarMax - tp.width;
    if (x < 0) x = 0;
    tp.paint(canvas, Offset(x, yAtas));
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (nilai.isEmpty) return;
    const sisi = 6.0, inset = 22.0, atas = 14.0, tinggiLabel = 30.0;
    final bawah = size.height - tinggiLabel;
    if (bawah <= atas || size.width <= 2 * (sisi + inset)) return;
    final n = nilai.length;

    // Rentang sumbu Y mengikuti data (kelipatan 5).
    var kecil = nilai.first;
    var besar = nilai.first;
    for (final v in nilai) {
      if (v < kecil) kecil = v;
      if (v > besar) besar = v;
    }
    final batasBawah = ((kecil - 4) ~/ 5 * 5).toDouble();
    var batasAtas = (((besar + 4) / 5).ceil() * 5).toDouble();
    if (batasAtas - batasBawah < 20) batasAtas = batasBawah + 20;

    double yDari(int v) =>
        bawah - (v - batasBawah) / (batasAtas - batasBawah) * (bawah - atas);
    double xDari(int i) => n == 1
        ? size.width / 2
        : inset + i * (size.width - 2 * inset) / (n - 1);

    // 3 garis bantu
    final garisBantu = Paint()
      ..color = const Color(0xFFEFEADC)
      ..strokeWidth = 1.4;
    for (var i = 0; i < 3; i++) {
      final y = atas + (bawah - atas) * i / 2;
      canvas.drawLine(Offset(sisi, y), Offset(size.width - sisi, y), garisBantu);
    }

    // Garis skor
    final jalur = Path();
    for (var i = 0; i < n; i++) {
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
        ..strokeWidth = n > 14 ? 2.6 : 3.5
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // Titik: kalau datanya banyak, hanya titik terakhir (hari ini).
    for (var i = 0; i < n; i++) {
      final terakhir = i == n - 1;
      if (!terakhir && n > 14) continue;
      final p = Offset(xDari(i), yDari(nilai[i]));
      if (terakhir) {
        canvas.drawCircle(p, 8, Paint()..color = AppColors.hijauTua);
      } else {
        canvas.drawCircle(p, 6.5, Paint()..color = Colors.white);
        canvas.drawCircle(
          p,
          6.5,
          Paint()
            ..color = AppColors.hijauSedang
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
    }

    // Label hari / tanggal
    for (var i = 0; i < n && i < label.length; i++) {
      if (label[i].isEmpty) continue;
      _teks(canvas, label[i], xDari(i), size.height - 22, size.width);
    }
  }

  @override
  bool shouldRepaint(covariant _GarisPainter old) =>
      old.nilai != nilai || old.label != label;
}
