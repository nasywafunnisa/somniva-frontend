import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/validator.dart';
import '../../shared/kolom_teks_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../beranda/beranda_page.dart';

/// Isian Login: email, kata sandi, tombol Masuk.
/// Dipakai oleh tampilan web dan tampilan HP.
class FormLogin extends StatefulWidget {
  /// Web menampilkan kotak "Ingat saya", HP tidak.
  final bool tampilIngatSaya;

  /// Web: "Lupa kata sandi?" bergaris bawah.
  final bool garisBawah;

  /// Widget di bawah tombol Masuk (tombol Google, dll).
  final Widget penutup;

  const FormLogin({
    super.key,
    required this.tampilIngatSaya,
    required this.garisBawah,
    required this.penutup,
  });

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _kunci = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  bool _lihatSandi = false;
  bool _ingat = true;

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _masuk() {
    if (!_kunci.currentState!.validate()) return;
    // Sementara belum ada server: login dianggap berhasil.
    // Nanti diganti dengan pengecekan ke PHP + MySQL.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BerandaPage()),
      (route) => false,
    );
  }

  void _segera(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lupa = TextButton(
      onPressed: () => _segera('Fitur lupa kata sandi akan ditambahkan nanti.'),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.hijauGelap,
      ),
      child: Text(
        'Lupa kata sandi?',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          decoration:
              widget.garisBawah ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );

    return Form(
      key: _kunci,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KolomTeks(
            label: 'Email',
            controller: _email,
            hint: 'nama@email.com',
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: widget.tampilIngatSaya
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (widget.tampilIngatSaya)
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _ingat = !_ingat),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _ingat,
                          onChanged: (v) => setState(() => _ingat = v ?? false),
                          activeColor: AppColors.hijauTua,
                          side: const BorderSide(
                            color: AppColors.hijauSedang,
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Ingat saya',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.teksSekunder,
                        ),
                      ),
                    ],
                  ),
                ),
              lupa,
            ],
          ),
          const SizedBox(height: 16),
          TombolUtama(teks: 'Masuk', onTap: _masuk),
          widget.penutup,
        ],
      ),
    );
  }
}
