import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/logo_somniva.dart';
import '../onboarding/onboarding_page.dart';

/// Layar pembuka (desain: 01 Splash).
/// Logo muncul pelan, lalu setelah beberapa detik pindah ke Onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kontrol;
  late final Animation<double> _muncul;
  late final Animation<double> _skala;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _kontrol = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _muncul = CurvedAnimation(parent: _kontrol, curve: Curves.easeOut);
    _skala = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _kontrol, curve: Curves.easeOutBack),
    );
    _kontrol.forward();

    _timer = Timer(const Duration(milliseconds: 2800), _lanjut);
  }

  void _lanjut() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const OnboardingPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _kontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran logo menyesuaikan layar: besar di HP, tidak kebesaran di web.
    final lebar = MediaQuery.of(context).size.width;
    final ukuranLogo = lebar < 500 ? lebar * 0.56 : 240.0;

    return Scaffold(
      backgroundColor: AppColors.krim,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _muncul,
                child: ScaleTransition(
                  scale: _skala,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LogoSomniva(ukuran: ukuranLogo),
                      const SizedBox(height: 40),
                      const Text(
                        'Somniva',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: AppColors.hijauGelap,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Tidur lebih tenang, pagi lebih ringan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 24,
              right: 24,
              bottom: 28,
              child: Text(
                'Indikator edukatif, bukan diagnosis medis',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
