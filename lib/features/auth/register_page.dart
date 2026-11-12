import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'auth_web_shell.dart';
import 'form_register.dart';
import 'login_page.dart';

/// Registrasi (desain: Website UI 02 Registrasi dan Mobile App UI 09 Registrasi).
/// Layar lebar -> tampilan web dua kolom. Layar sempit -> tampilan HP.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const double _batasWeb = 900;

  void _keLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= _batasWeb) return _web(context);
        return _mobile(context);
      },
    );
  }

  // ---------- Tampilan web ----------
  Widget _web(BuildContext context) {
    return AuthWebShell(
      tabAktif: 1,
      onMasuk: () => _keLogin(context),
      onDaftar: () {},
      judul: 'Buat akun Somniva',
      subjudul: 'Mulai kenali pola tidurmu dalam satu menit.',
      form: const FormRegister(tataLetakHp: false),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: AppColors.krim,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _keLogin(context),
                        child: const SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Buat akun Somniva',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mulai kenali pola tidurmu dalam 1 menit.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: FormRegister(
                      tataLetakHp: true,
                      penutup: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: GestureDetector(
                          onTap: () => _keLogin(context),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.teksSekunder,
                                ),
                              ),
                              Text(
                                'Masuk',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
