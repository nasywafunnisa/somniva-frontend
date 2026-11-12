import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/logo_somniva.dart';
import '../../shared/tombol_somniva.dart';
import 'auth_web_shell.dart';
import 'form_login.dart';
import 'register_page.dart';

/// Login (desain: Website UI 01 Login dan Mobile App UI 10 Login).
/// Layar lebar -> tampilan web dua kolom. Layar sempit -> tampilan HP.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const double _batasWeb = 900;

  void _keDaftar(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const RegisterPage(),
      ),
    );
  }

  void _segera(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Masuk dengan Google akan ditambahkan nanti.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= _batasWeb) {
          return _web(context);
        }
        return _mobile(context);
      },
    );
  }

  // ---------- Tampilan web ----------
  Widget _web(BuildContext context) {
    return AuthWebShell(
      tabAktif: 0,
      onMasuk: () {},
      onDaftar: () => _keDaftar(context),
      judul: 'Selamat datang kembali',
      subjudul: 'Masuk untuk melihat analisis tidurmu.',
      form: FormLogin(
        tampilIngatSaya: true,
        garisBawah: true,
        penutup: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 14),
            TombolGaris(
              teks: 'Lanjutkan dengan Google',
              onTap: () => _segera(context),
            ),
            const SizedBox(height: 14),
            const Text(
              'Skor dan rekomendasi bersifat edukatif, bukan diagnosis medis.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Tampilan HP ----------
  Widget _mobile(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 40, 22, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: IkonBulan(ukuran: 62),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Selamat datang kembali',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Masuk untuk melihat skor dan program tidurmu.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                        const SizedBox(height: 22),
                        FormLogin(
                          tampilIngatSaya: false,
                          garisBawah: false,
                          penutup: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              const _PemisahAtau(),
                              const SizedBox(height: 16),
                              TombolGaris(
                                teks: 'Lanjutkan dengan Google',
                                onTap: () => _segera(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
                  child: GestureDetector(
                    onTap: () => _keDaftar(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                        Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PemisahAtau extends StatelessWidget {
  const _PemisahAtau();

  @override
  Widget build(BuildContext context) {
    const garis = Expanded(
      child: Divider(color: AppColors.hijauPastel, thickness: 1.2, height: 1),
    );
    return const Row(
      children: [
        garis,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'atau',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ),
        garis,
      ],
    );
  }
}
