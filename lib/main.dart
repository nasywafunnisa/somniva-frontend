import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/filter_gelap.dart';
import 'core/store_tema.dart';
import 'features/admin/auth/login_admin_page.dart';
import 'features/auth/login_page.dart';
import 'features/splash/splash_page.dart';

/// Ubah jadi true kalau ingin MELIHAT tampilan aplikasi (splash + onboarding)
/// di Chrome saat pengembangan. Kembalikan ke false untuk versi web asli.
const bool lihatSebagaiAplikasi = false;

/// Ubah jadi true kalau ingin langsung membuka WEB ADMIN saat pengembangan.
/// Cara lain tanpa mengubah kode: buka alamat dengan akhiran /#/admin
/// (contoh: http://localhost:5000/#/admin). Kembalikan ke false untuk normal.
const bool lihatSebagaiAdmin = false;

/// Apakah halaman ini dibuka sebagai web admin (khusus web).
bool get _bukaAdmin {
  if (!kIsWeb) return false;
  if (lihatSebagaiAdmin) return true;
  final alamat = Uri.base;
  return alamat.path.startsWith('/admin') ||
      alamat.fragment.startsWith('/admin');
}

void main() {
  runApp(const SomnivaApp());
}

class SomnivaApp extends StatefulWidget {
  const SomnivaApp({super.key});

  @override
  State<SomnivaApp> createState() => _SomnivaAppState();
}

class _SomnivaAppState extends State<SomnivaApp> {
  Timer? _jam;

  @override
  void initState() {
    super.initState();
    // Cek tiap menit supaya "Otomatis saat malam" berganti sendiri.
    _jam = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted && StoreTema.instance.otomatisMalam) setState(() {});
    });
  }

  @override
  void dispose() {
    _jam?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Web: langsung Login. Aplikasi: Splash dulu.
    // Alamat /admin: Login Admin.
    final bool tampilWeb = kIsWeb && !lihatSebagaiAplikasi;
    final bool tampilAdmin = _bukaAdmin;

    return ListenableBuilder(
      listenable: StoreTema.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'Somniva',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.terang,
          builder: (context, child) {
            final gelap = StoreTema.instance
                .gelapSekarang(MediaQuery.platformBrightnessOf(context));
            return FilterGelap(
              aktif: gelap,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: tampilAdmin
              ? const LoginAdminPage()
              : (tampilWeb ? const LoginPage() : const SplashPage()),
        );
      },
    );
  }
}
