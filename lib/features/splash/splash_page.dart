import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../shared/logo_somniva.dart';
import '../onboarding/onboarding_page.dart';

// Palet splash (sesuai desain revisi). Semuanya hijau sage + krem.
const Color _krem = Color(0xFFF4F0E8);
const Color _hijauSangatMuda = Color(0xFFE5EBDF);
const Color _hijauMuda = Color(0xFFDBE1D3);
const Color _sage = Color(0xFF78856B);
const Color _hijauKeabuan = Color(0xFF5F6B58);
const Color _hijauTuaGelap = Color(0xFF2A3A28);

/// Layar pembuka (desain revisi: langit malam yang tenang).
/// Urutan: logo -> nama -> tagline -> ikon -> titik loading -> catatan,
/// lalu pindah ke Onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  /// Lama animasi masuk (detik). Semua Interval di bawah memakai skala ini.
  static const double _durMasuk = 2.2;

  /// Berapa lama splash tampil sebelum pindah ke Onboarding.
  static const Duration _lamaTampil = Duration(milliseconds: 4200);

  late final AnimationController _masuk;
  late final AnimationController _ulang;
  late final Animation<double> _logo;
  late final Animation<double> _logoSkala;
  late final Animation<double> _nama;
  late final Animation<double> _tagline;
  late final Animation<double> _garis;
  late final Animation<double> _ikon;
  late final Animation<double> _titik;
  late final Animation<double> _catatan;
  Timer? _timer;

  Animation<double> _iv(double a, double b, Curve c) => CurvedAnimation(
        parent: _masuk,
        curve: Interval(a / _durMasuk, b / _durMasuk, curve: c),
      );

  @override
  void initState() {
    super.initState();
    _masuk = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_durMasuk * 1000).round()),
    )..forward();

    // Pengendali gerakan yang terus berulang. Nilainya dipakai sebagai
    // "detik berjalan" oleh semua painter (lihat _detik).
    _ulang = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3600),
    )..repeat();

    _logo = _iv(0, 1.0, Curves.easeOut);
    _logoSkala = Tween<double>(begin: 0.6, end: 1).animate(
      _iv(0, 1.0, Curves.easeOutBack),
    );
    _nama = _iv(0.5, 1.4, Curves.easeOutCubic);
    _tagline = _iv(0.75, 1.65, Curves.easeOutCubic);
    _garis = _iv(0, 1.0, Curves.easeOut);
    _ikon = _iv(1.3, 2.0, Curves.easeOutCubic);
    _titik = _iv(1.4, 2.0, Curves.easeOut);
    _catatan = _iv(1.6, 2.2, Curves.easeOut);

    _timer = Timer(_lamaTampil, _lanjut);
  }

  void _lanjut() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const OnboardingPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _masuk.dispose();
    _ulang.dispose();
    super.dispose();
  }

  Widget _muncul(Animation<double> a, Widget anak, {double naik = 16}) {
    return AnimatedBuilder(
      animation: a,
      builder: (context, child) => Opacity(
        opacity: a.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - a.value) * naik),
          child: child,
        ),
      ),
      child: anak,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _krem,
      body: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final h = box.maxHeight;
          final lebarIsi = math.min(w, 460.0);
          final ukuranLogo = (lebarIsi * 0.46).clamp(120.0, 190.0);
          final blok = ukuranLogo * 1.95;
          final tampilIkon = h >= 760;

          return Stack(
            children: [
              // Pola titik halus (diam), memudar di tengah.
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(painter: _TitikPainter()),
                ),
              ),
              // Gumpalan cahaya, awan, bintang atas, bintang jatuh.
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(painter: _LatarPainter(_ulang)),
                ),
              ),
              // Bukit di dasar layar.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 130,
                child: RepaintBoundary(
                  child: CustomPaint(painter: _BukitPainter()),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SizedBox(
                    width: lebarIsi,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedBuilder(
                                    animation: _masuk,
                                    builder: (context, child) => Opacity(
                                      opacity: _logo.value.clamp(0.0, 1.0),
                                      child: Transform.scale(
                                        scale: _logoSkala.value,
                                        child: child,
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: blok,
                                      height: blok,
                                      child: RepaintBoundary(
                                        child: CustomPaint(
                                          painter: _LogoBlokPainter(
                                              _ulang, ukuranLogo),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _muncul(
                                    _nama,
                                    const Text(
                                      'Somniva',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 46,
                                        fontWeight: FontWeight.w800,
                                        color: _hijauTuaGelap,
                                        letterSpacing: -1.2,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _muncul(
                                    _tagline,
                                    const Text(
                                      'Tidur lebih tenang, pagi lebih ringan',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w500,
                                        color: _hijauKeabuan,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  AnimatedBuilder(
                                    animation: _garis,
                                    builder: (context, _) => Container(
                                      width: 44 * _garis.value,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: _sage.withAlpha(150),
                                        borderRadius:
                                            BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (tampilIkon) ...[
                          _muncul(_ikon, const _BarisIkon(), naik: 20),
                          const SizedBox(height: 26),
                        ],
                        AnimatedBuilder(
                          animation: _titik,
                          builder: (context, child) => Opacity(
                            opacity: _titik.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                          child: _TitikLoading(_ulang),
                        ),
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _catatan,
                          builder: (context, child) => Opacity(
                            opacity: _catatan.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Indikator edukatif, bukan diagnosis medis',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: _hijauKeabuan,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =============================================================================
// Utilitas waktu
// =============================================================================

/// Detik berjalan dari pengendali berulang (nilai 0..1 dari 3600 detik).
double _detik(AnimationController c) => c.value * 3600;

double _mod(double a, double b) => a - b * (a / b).floorToDouble();

/// Gelombang naik-turun lembut 0..1.
double _napas(double sec, double periode, [double fase = 0]) =>
    0.5 + 0.5 * math.sin(2 * math.pi * (sec / periode + fase));

// =============================================================================
// Baris empat ikon
// =============================================================================

class _BarisIkon extends StatelessWidget {
  const _BarisIkon();

  @override
  Widget build(BuildContext context) {
    const ikon = [
      Icons.dark_mode_outlined,
      Icons.schedule_rounded,
      Icons.show_chart_rounded,
      Icons.check_rounded,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final i in ikon)
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: _hijauSangatMuda,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x142A3A28),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(i, size: 20, color: _sage),
          ),
      ],
    );
  }
}

// =============================================================================
// Tiga titik loading
// =============================================================================

class _TitikLoading extends StatelessWidget {
  final AnimationController ulang;
  const _TitikLoading(this.ulang);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ulang,
      builder: (context, _) {
        final sec = _detik(ulang);
        return SizedBox(
          height: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < 3; i++)
                Builder(builder: (context) {
                  final v = math.sin(2 * math.pi * ((sec - i * 0.18) / 1.3));
                  final naik = v > 0 ? v * 7 : 0.0;
                  return Container(
                    width: 6,
                    height: 6,
                    margin: EdgeInsets.fromLTRB(4, 0, 4, naik),
                    decoration: const BoxDecoration(
                      color: _sage,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Latar: pola titik (diam)
// =============================================================================

class _TitikPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const jarak = 22.0;
    final pusat = Offset(size.width / 2, size.height * 0.40);
    final jari = math.min(size.width, size.height) * 0.55;
    final cat = Paint();
    for (double y = jarak / 2; y < size.height; y += jarak) {
      for (double x = jarak / 2; x < size.width; x += jarak) {
        final d = (Offset(x, y) - pusat).distance;
        // Tengah (area logo) bersih, makin ke tepi makin terlihat.
        final f = ((d / jari) - 0.35).clamp(0.0, 1.0);
        if (f <= 0) continue;
        cat.color = _sage.withAlpha((f * 38).round());
        canvas.drawCircle(Offset(x, y), 1.1, cat);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// Latar bergerak: cahaya blur, awan, bintang atas, bintang jatuh
// =============================================================================

class _LatarPainter extends CustomPainter {
  final AnimationController ulang;
  _LatarPainter(this.ulang) : super(repaint: ulang);

  void _cahaya(Canvas canvas, Offset pusat, double r, Color warna, int alpha) {
    final rect = Rect.fromCircle(center: pusat, radius: r);
    canvas.drawCircle(
      pusat,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [warna.withAlpha(alpha), warna.withAlpha(0)],
        ).createShader(rect),
    );
  }

  void _awan(Canvas canvas, double x, double y, double lebar, Color warna) {
    final tinggi = lebar * 0.26;
    final cat = Paint()..color = warna;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, lebar, tinggi),
        Radius.circular(tinggi / 2),
      ),
      cat,
    );
    canvas.drawCircle(Offset(x + lebar * 0.32, y), tinggi * 0.62, cat);
    canvas.drawCircle(Offset(x + lebar * 0.60, y - tinggi * 0.12), tinggi * 0.78, cat);
  }

  void _bintangTitik(Canvas canvas, Offset p, double r, double alpha) {
    canvas.drawCircle(p, r, Paint()..color = _sage.withAlpha((alpha * 255).round().clamp(0, 255)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final sec = _detik(ulang);
    final w = size.width;
    final h = size.height;

    // Dua gumpalan cahaya, bergeser berlawanan arah.
    final g1 = 20 * math.sin(2 * math.pi * sec / 12);
    final g2 = 20 * math.sin(2 * math.pi * sec / 14 + math.pi);
    _cahaya(canvas, Offset(w * 0.95 + g1, h * 0.06 - g1 * 0.5), w * 0.62,
        _hijauSangatMuda, 255);
    _cahaya(canvas, Offset(w * 0.05 + g2, h * 0.92 + g2 * 0.5), w * 0.9,
        _hijauMuda, 120);

    // Dua awan melintas dari kiri ke kanan.
    final lebarA = math.min(w * 0.42, 190.0);
    final jalurA = w + lebarA * 2;
    _awan(canvas, _mod(sec / 38, 1) * jalurA - lebarA, h * 0.30, lebarA,
        _hijauMuda.withAlpha(150));
    final lebarB = lebarA * 0.62;
    final jalurB = w + lebarB * 2;
    _awan(canvas, _mod(sec / 54 + 0.45, 1) * jalurB - lebarB, h * 0.52, lebarB,
        _hijauMuda.withAlpha(90));

    // Lima bintang kecil di bagian atas.
    const atas = [
      [0.16, 0.040, 2.6, 0.0],
      [0.32, 0.075, 1.8, 0.3],
      [0.52, 0.030, 2.2, 0.55],
      [0.70, 0.070, 1.6, 0.15],
      [0.86, 0.045, 2.4, 0.7],
    ];
    for (final b in atas) {
      final k = _napas(sec, 3.4, b[3]);
      _bintangTitik(canvas, Offset(w * b[0], h * b[1] + 18), b[2] * (0.9 + 0.2 * k),
          0.25 + 0.5 * k);
    }

    // Bintang jatuh: siklus 9 detik, terlihat 1,5 detik di akhir siklus.
    final t = _mod(sec, 9) - 7.5;
    if (t >= 0) {
      final q = t / 1.5;
      final arah = Offset(-1, 1) / math.sqrt2;
      final kepala = Offset(w * 0.92, h * 0.07) + arah * (300 * q);
      final ekor = kepala - arah * 80;
      final alpha = q < 0.2 ? q / 0.2 : (1 - q) / 0.8;
      canvas.drawLine(
        ekor,
        kepala,
        Paint()
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [
              _sage.withAlpha(0),
              _sage.withAlpha((alpha * 220).round().clamp(0, 255)),
            ],
          ).createShader(Rect.fromPoints(ekor, kepala)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LatarPainter old) => false;
}

// =============================================================================
// Bukit di dasar layar
// =============================================================================

class _BukitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final belakang = Path()
      ..moveTo(0, h * 0.42)
      ..cubicTo(w * 0.22, h * 0.10, w * 0.50, h * 0.62, w * 0.74, h * 0.34)
      ..cubicTo(w * 0.86, h * 0.20, w * 0.95, h * 0.30, w, h * 0.26)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(belakang, Paint()..color = _hijauMuda);

    final depan = Path()
      ..moveTo(0, h * 0.66)
      ..cubicTo(w * 0.25, h * 0.38, w * 0.55, h * 0.92, w * 0.80, h * 0.58)
      ..cubicTo(w * 0.90, h * 0.46, w * 0.96, h * 0.54, w, h * 0.50)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(depan, Paint()..color = _hijauSangatMuda);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// Blok logo: cincin gelombang, orbit, logo melayang, bintang, huruf z
// =============================================================================

class _LogoBlokPainter extends CustomPainter {
  final AnimationController ulang;
  final double ukuran; // diameter lingkaran luar logo
  _LogoBlokPainter(this.ulang, this.ukuran) : super(repaint: ulang);

  void _kilau(Canvas canvas, Offset p, double r, double alpha) {
    final dalam = r * 0.28;
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final sudut = -math.pi / 2 + i * math.pi / 4;
      final jari = i.isEven ? r : dalam;
      final titik = p + Offset(math.cos(sudut), math.sin(sudut)) * jari;
      if (i == 0) {
        path.moveTo(titik.dx, titik.dy);
      } else {
        path.lineTo(titik.dx, titik.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()..color = _sage.withAlpha((alpha * 255).round().clamp(0, 255)),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final sec = _detik(ulang);
    final s = size.width;
    final pusat = Offset(s / 2, s / 2);
    final L = ukuran;

    // --- Tiga cincin gelombang (siklus 4,5 dtk, selisih 1,5 dtk) ---
    for (var i = 0; i < 3; i++) {
      final p = _mod(sec - i * 1.5, 4.5) / 4.5;
      final r = (L / 2) * (1 + 0.7 * p);
      canvas.drawCircle(
        pusat,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3
          ..color = _sage.withAlpha(((1 - p) * 70).round()),
      );
    }

    // --- Orbit putus-putus, berputar 1 putaran / 40 dtk ---
    final ro = L * 0.86;
    final putar = 2 * math.pi * sec / 40;
    const n = 72;
    final cOrbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _sage.withAlpha(90);
    final rect = Rect.fromCircle(center: pusat, radius: ro);
    for (var k = 0; k < n; k++) {
      canvas.drawArc(rect, putar + k * 2 * math.pi / n, math.pi / n, false, cOrbit);
    }
    canvas.drawCircle(
      pusat + Offset(math.cos(putar - 0.8), math.sin(putar - 0.8)) * ro,
      3.2,
      Paint()..color = _sage,
    );

    // --- Logo melayang naik-turun (+-4 px, siklus 6 dtk) ---
    final dy = -4 * math.sin(2 * math.pi * sec / 6);
    final tilt = (3 * math.pi / 180) * math.sin(2 * math.pi * sec / 7);

    canvas.save();
    canvas.translate(0, dy);
    canvas.drawCircle(pusat, L / 2, Paint()..color = _hijauSangatMuda);
    canvas.drawCircle(pusat, L * 0.39, Paint()..color = _hijauMuda);

    canvas.save();
    canvas.translate(pusat.dx, pusat.dy);
    canvas.rotate(tilt);
    canvas.translate(-pusat.dx, -pusat.dy);
    canvas.drawPath(bulanSabit(pusat, L * 0.23), Paint()..color = _sage);
    canvas.restore();

    final titik = Paint()..color = _sage;
    final kiriAtas = pusat + Offset(-L * 0.21, -L * 0.21);
    final kananBawah = pusat + Offset(L * 0.19, L * 0.18);
    canvas.drawCircle(kiriAtas, L * 0.022, titik);
    canvas.drawCircle(kananBawah, L * 0.015, titik);
    canvas.restore();

    // --- Enam bintang di sekitar logo (berkedip bergantian) ---
    // x, y (pecahan blok), jari-jari, fase, bentuk (true = kilau, false = titik)
    const bintang = [
      [0.10, 0.30, 7.0, 0.00, 1.0],
      [0.92, 0.40, 5.0, 0.35, 1.0],
      [0.88, 0.86, 7.0, 0.70, 1.0],
      [0.05, 0.64, 4.5, 0.20, 1.0],
      [0.30, 0.05, 2.6, 0.50, 0.0],
      [0.84, 0.74, 2.2, 0.85, 0.0],
    ];
    for (final b in bintang) {
      final k = _napas(sec, 3.4, b[3]);
      final p = Offset(s * b[0], s * b[1]);
      final r = b[2] * (0.85 + 0.3 * k);
      final alpha = 0.12 + 0.6 * k;
      if (b[4] == 1.0) {
        _kilau(canvas, p, r, alpha);
      } else {
        canvas.drawCircle(
          p,
          r,
          Paint()..color = _sage.withAlpha((alpha * 255).round().clamp(0, 255)),
        );
      }
    }

    // --- Huruf z naik ke kanan atas (siklus 5 dtk, jeda 1,6 dtk) ---
    const huruf = [
      ['z', 13.0],
      ['z', 17.0],
      ['Z', 23.0],
    ];
    final asal = Offset(s * 0.74, s * 0.26);
    for (var i = 0; i < 3; i++) {
      final p = _mod(sec - i * 1.6, 5) / 5;
      final a = p < 0.2 ? p / 0.2 : (1 - p) / 0.8;
      final tp = TextPainter(
        text: TextSpan(
          text: huruf[i][0] as String,
          style: TextStyle(
            fontSize: huruf[i][1] as double,
            fontWeight: FontWeight.w800,
            color: _sage.withAlpha((a * 190).round().clamp(0, 255)),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(asal.dx + 50 * p, asal.dy - 50 * p);
      canvas.rotate(0.35 * p);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LogoBlokPainter old) => old.ukuran != ukuran;
}
