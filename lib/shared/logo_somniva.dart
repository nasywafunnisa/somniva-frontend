import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Bentuk bulan sabit: lingkaran besar dikurangi lingkaran kecil yang digeser.
Path bulanSabit(Offset pusat, double r) {
  final besar = Path()..addOval(Rect.fromCircle(center: pusat, radius: r));
  final potong = Path()
    ..addOval(Rect.fromCircle(
      center: pusat.translate(r * 0.42, -r * 0.26),
      radius: r * 0.8,
    ));
  return Path.combine(PathOperation.difference, besar, potong);
}

/// Logo Somniva: bulan sabit di dalam dua lingkaran hijau lembut.
/// Digambar dengan kode, jadi tidak perlu file gambar.
class LogoSomniva extends StatelessWidget {
  final double ukuran;
  const LogoSomniva({super.key, this.ukuran = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final pusat = Offset(s / 2, s / 2);

    canvas.drawCircle(pusat, s / 2, Paint()..color = AppColors.hijauMuda);
    canvas.drawCircle(pusat, s * 0.37, Paint()..color = AppColors.hijauPastel);

    canvas.drawPath(
      bulanSabit(pusat, s * 0.22),
      Paint()..color = AppColors.hijauSedang,
    );

    final titik = Paint()..color = AppColors.hijauSedang;
    canvas.drawCircle(Offset(s * 0.29, s * 0.29), s * 0.016, titik);
    canvas.drawCircle(Offset(s * 0.69, s * 0.68), s * 0.011, titik);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ikon bulat kecil berisi bulan sabit (dipakai di Login versi HP).
class IkonBulan extends StatelessWidget {
  final double ukuran;
  const IkonBulan({super.key, this.ukuran = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: const BoxDecoration(
        color: AppColors.hijauPastel,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(painter: _IkonBulanPainter()),
    );
  }
}

class _IkonBulanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pusat = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawPath(
      bulanSabit(pusat, size.width * 0.24),
      Paint()..color = AppColors.hijauSedang,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
