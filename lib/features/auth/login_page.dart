import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/logo_somniva.dart';
import '../../shared/tombol_somniva.dart';
import 'auth_web_shell.dart';
import 'form_login.dart';
import 'register_page.dart';

/// Login (desain: Website UI 01 Login dan Mobile App UI 10 Login).
/// Layar lebar -> split screen dengan panel melengkung (AuthWebShell).
/// Layar sempit -> satu kolom dengan header melengkung.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const double _batasWeb = 900;

  /// Di bawah tinggi ini, header melengkung disembunyikan supaya form tidak sesak.
  static const double _tinggiMinHeader = 640;

  void _keDaftar(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PeralihanAuth.rute(const RegisterPage(), dariKanan: true),
    );
  }

  static void _segera(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Masuk dengan Google akan ditambahkan nanti.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Isi sisi "Masuk" untuk tampilan web. Dipakai juga oleh RegisterPage,
  /// karena kedua form ada di kerangka yang sama.
  static IsiAuth isiWeb(BuildContext context) {
    return IsiAuth(
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= _batasWeb) {
          return _web(context);
        }
        return _mobile(context, box.maxHeight);
      },
    );
  }

  // ---------- Tampilan web ----------
  Widget _web(BuildContext context) {
    return AuthWebShell(
      tabAwal: 0,
      isiMasuk: isiWeb(context),
      isiDaftar: RegisterPage.isiWeb(context),
    );
  }

  // ---------- Tampilan HP / tablet portrait ----------
  Widget _mobile(BuildContext context, double tinggiLayar) {
    final tampilHeader = tinggiLayar >= _tinggiMinHeader;

    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Column(
        children: [
          if (tampilHeader) const AuthHeaderMelengkung(tinggi: 150),
          Expanded(
            child: SafeArea(
              top: !tampilHeader,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                              22, tampilHeader ? 14 : 40, 22, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!tampilHeader) ...const [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IkonBulan(ukuran: 62),
                                ),
                                SizedBox(height: 26),
                              ],
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
          ),
        ],
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
