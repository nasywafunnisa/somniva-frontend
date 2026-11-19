import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'auth_web_shell.dart';
import 'form_register.dart';
import 'login_page.dart';

/// Registrasi (desain: Website UI 02 Registrasi dan Mobile App UI 09 Registrasi).
/// Layar lebar -> split screen dengan panel melengkung (AuthWebShell).
/// Layar sempit -> satu kolom dengan header melengkung.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const double _batasWeb = 900;

  /// Di bawah tinggi ini, header melengkung disembunyikan supaya form tidak sesak.
  static const double _tinggiMinHeader = 640;

  void _keLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PeralihanAuth.rute(const LoginPage(), dariKanan: false),
    );
  }

  /// Isi sisi "Daftar" untuk tampilan web. Dipakai juga oleh LoginPage,
  /// karena kedua form ada di kerangka yang sama.
  static IsiAuth isiWeb(BuildContext context) {
    return const IsiAuth(
      judul: 'Buat akun Somniva',
      subjudul: 'Mulai kenali pola tidurmu dalam satu menit.',
      form: FormRegister(tataLetakHp: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= _batasWeb) return _web(context);
        return _mobile(context, box.maxHeight);
      },
    );
  }

  // ---------- Tampilan web ----------
  Widget _web(BuildContext context) {
    return AuthWebShell(
      tabAwal: 1,
      isiMasuk: LoginPage.isiWeb(context),
      isiDaftar: isiWeb(context),
    );
  }

  // ---------- Tampilan HP / tablet portrait ----------
  Widget _mobile(BuildContext context, double tinggiLayar) {
    final tampilHeader = tinggiLayar >= _tinggiMinHeader;

    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Column(
        children: [
          if (tampilHeader)
            AuthHeaderMelengkung(
              tinggi: 150,
              onKembali: () => _keLogin(context),
            ),
          Expanded(
            child: SafeArea(
              top: !tampilHeader,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        22, tampilHeader ? 14 : 22, 22, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!tampilHeader) ...[
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
                        ],
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
          ),
        ],
      ),
    );
  }
}
