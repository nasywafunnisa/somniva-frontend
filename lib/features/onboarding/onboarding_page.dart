import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../shared/tombol_somniva.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import 'ilustrasi_onboarding.dart';

class _IsiHalaman {
  final String judul;
  final String deskripsi;
  const _IsiHalaman(this.judul, this.deskripsi);
}

/// Onboarding 3 halaman (desain: 02 Onboarding).
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _halaman = 0;

  static const List<_IsiHalaman> _isi = [
    _IsiHalaman(
      'Pahami pola tidurmu, bukan sekadar jamnya',
      'Catat kebiasaan harian, lihat hubungannya dengan kualitas tidur, lalu ikuti program kecil yang terarah.',
    ),
    _IsiHalaman(
      'Lihat skor dan utang tidurmu',
      'Sleep Score dan Sleep Debt menunjukkan seberapa cukup tidurmu, dan faktor apa yang paling memengaruhinya.',
    ),
    _IsiHalaman(
      'Ikuti program 14 hari yang ringan',
      'Langkah kecil tiap malam: rutinitas wind-down, pengingat tidur, dan latihan relaksasi.',
    ),
  ];

  bool get _terakhir => _halaman == _isi.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _lanjut() {
    if (_terakhir) {
      _keRegistrasi();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _keRegistrasi() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  void _keLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          // Di layar lebar (web) isi dibatasi supaya tetap rapi seperti HP.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
              child: Column(
                children: [
                  _barisAtas(),
                  const SizedBox(height: 14),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _isi.length,
                      onPageChanged: (i) => setState(() => _halaman = i),
                      itemBuilder: (context, i) => _kontenHalaman(i),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _indikator(),
                  const SizedBox(height: 28),
                  TombolUtama(
                    teks: _terakhir ? 'Mulai' : 'Lanjut',
                    onTap: _lanjut,
                  ),
                  const SizedBox(height: 14),
                  TombolGaris(
                    teks: 'Sudah punya akun? Masuk',
                    onTap: _keLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _barisAtas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_halaman + 1} dari ${_isi.length}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.teksSekunder,
          ),
        ),
        Material(
          color: AppColors.krim,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _keRegistrasi,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              child: Text(
                'Lewati',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kontenHalaman(int i) {
    final isi = _isi[i];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: IlustrasiOnboarding(halaman: i)),
        const SizedBox(height: 22),
        Text(
          isi.judul,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.18,
            letterSpacing: -0.5,
            color: AppColors.hijauGelap,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isi.deskripsi,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: AppColors.teksSekunder,
          ),
        ),
      ],
    );
  }

  Widget _indikator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_isi.length, (i) {
        final aktif = i == _halaman;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: aktif ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: aktif ? AppColors.hijauTua : AppColors.titikMati,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
