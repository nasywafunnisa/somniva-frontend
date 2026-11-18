import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../core/validator.dart';
import '../../../shared/kartu_somniva.dart';
import '../../../shared/kolom_teks_somniva.dart';
import '../../../shared/logo_somniva.dart';
import '../../../shared/tombol_somniva.dart';
import '../shell_admin.dart';
import '../widget/kepala_admin.dart';

/// Login Admin (desain: Website UI Admin 01 Login Admin).
/// Halaman terpisah dari login pengguna. Dibuka lewat alamat /admin.
class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final _kunci = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  bool _lihatSandi = false;
  String? _galat;

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _masuk() {
    if (!_kunci.currentState!.validate()) return;
    // Sementara belum ada server: dicek ke akun contoh di StoreAdmin.
    // Nanti diganti dengan pengecekan ke PHP + MySQL.
    if (!StoreAdmin.instance.cekMasuk(_email.text, _sandi.text)) {
      setState(() => _galat = 'Email atau kata sandi admin salah.');
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const ShellAdmin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: KartuSomniva(
                  radius: 32,
                  padding: const EdgeInsets.fromLTRB(38, 36, 38, 32),
                  child: _isi(),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 28,
            right: 32,
            child: TombolBulanAdmin(),
          ),
        ],
      ),
    );
  }

  Widget _isi() {
    return Form(
      key: _kunci,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IkonBulan(ukuran: 40),
              const SizedBox(width: 12),
              const Text(
                'Somniva',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.krim,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Masuk Admin',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Akses khusus pengelola Somniva.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          const SizedBox(height: 22),
          KolomTeks(
            label: 'Email admin',
            controller: _email,
            hint: 'admin@somniva.id',
            jenisKeyboard: TextInputType.emailAddress,
            aksi: TextInputAction.next,
            validator: Validator.email,
          ),
          const SizedBox(height: 16),
          KolomTeks(
            label: 'Kata sandi',
            controller: _sandi,
            hint: 'Masukkan kata sandi',
            sembunyikan: !_lihatSandi,
            aksi: TextInputAction.done,
            onSubmitted: (_) => _masuk(),
            validator: Validator.sandi,
            ikonKanan: IconButton(
              onPressed: () => setState(() => _lihatSandi = !_lihatSandi),
              icon: Icon(
                _lihatSandi
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.teksSekunder,
                size: 22,
              ),
            ),
          ),
          if (_galat != null) ...[
            const SizedBox(height: 12),
            Text(
              _galat!,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB3563F),
              ),
            ),
          ],
          const SizedBox(height: 18),
          TombolUtama(teks: 'Masuk', onTap: _masuk),
          const SizedBox(height: 16),
          const Text(
            'Panel ini tidak menampilkan isi jurnal tidur pribadi pengguna.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}
