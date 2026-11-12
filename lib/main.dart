import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/splash/splash_page.dart';

/// Ubah jadi true kalau ingin MELIHAT tampilan aplikasi (splash + onboarding)
/// di Chrome saat pengembangan. Kembalikan ke false untuk versi web asli.
const bool lihatSebagaiAplikasi = false;

void main() {
  runApp(const SomnivaApp());
}

class SomnivaApp extends StatelessWidget {
  const SomnivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Web: langsung Login. Aplikasi: Splash dulu.
    final bool tampilWeb = kIsWeb && !lihatSebagaiAplikasi;

    return MaterialApp(
      title: 'Somniva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.terang,
      home: tampilWeb ? const LoginPage() : const SplashPage(),
    );
  }
}
