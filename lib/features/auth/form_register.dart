import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/validator.dart';
import '../../shared/kolom_teks_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../beranda/beranda_page.dart';

/// Isian Registrasi: nama, email, kata sandi, target tidur, persetujuan.
/// Dipakai oleh tampilan web dan tampilan HP.
class FormRegister extends StatefulWidget {
  /// true = tata letak HP (tombol Daftar menempel di bawah layar).
  final bool tataLetakHp;

  /// Widget di bawah tombol Daftar (contoh: "Sudah punya akun? Masuk").
  final Widget? penutup;

  const FormRegister({super.key, required this.tataLetakHp, this.penutup});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final _kunci = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _sandi = TextEditingController();
  bool _lihatSandi = false;
  int _targetJam = 8;
  bool _setuju = true;
  bool _setujuError = false;

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _daftar() {
    final formOk = _kunci.currentState!.validate();
    if (!_setuju) {
      setState(() => _setujuError = true);
    }
    if (!formOk || !_setuju) return;

    // Sementara belum ada server: pendaftaran dianggap berhasil.
    // Nama dan target tidur nanti disimpan ke database.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BerandaPage()),
      (route) => false,
    );
  }

  Widget _pilihanTarget() {
    final chips = Row(
      mainAxisSize: MainAxisSize.min,
      children: [7, 8, 9].map((jam) {
        final aktif = jam == _targetJam;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _targetJam = jam),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aktif ? AppColors.hijauTua : AppColors.krim,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$jam jam',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: aktif ? Colors.white : AppColors.hijauGelap,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (widget.tataLetakHp) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Target tidur per malam',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 12),
          chips,
        ],
      );
    }

    // Web: label dan pilihan sebaris
    return Row(
      children: [
        const SizedBox(
          width: 130,
          child: Text(
            'Target tidur',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ),
        chips,
      ],
    );
  }

  Widget _persetujuan() {
    final teks = widget.tataLetakHp
        ? 'Saya setuju data tidur saya diproses sesuai Kebijakan Privasi. Data tidak dipakai untuk diagnosis.'
        : 'Saya setuju data tidur saya diproses sesuai Kebijakan Privasi.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() {
            _setuju = !_setuju;
            if (_setuju) _setujuError = false;
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _setuju,
                  onChanged: (v) => setState(() {
                    _setuju = v ?? false;
                    if (_setuju) _setujuError = false;
                  }),
                  activeColor: AppColors.hijauTua,
                  side: BorderSide(
                    color: _setujuError
                        ? const Color(0xFFB3563F)
                        : AppColors.hijauSedang,
                    width: 1.4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  teks,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_setujuError)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 36),
            child: Text(
              'Centang persetujuan untuk melanjutkan',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB3563F),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hp = widget.tataLetakHp;

    final isian = <Widget>[
      KolomTeks(
        label: 'Nama',
        controller: _nama,
        hint: 'Nama lengkap',
        jenisKeyboard: TextInputType.name,
        aksi: TextInputAction.next,
        validator: Validator.nama,
      ),
      const SizedBox(height: 16),
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
        hint: 'Minimal 6 karakter',
        sembunyikan: !_lihatSandi,
        aksi: TextInputAction.done,
        onSubmitted: (_) => _daftar(),
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
      SizedBox(height: hp ? 22 : 16),
      _pilihanTarget(),
      SizedBox(height: hp ? 20 : 14),
      _persetujuan(),
    ];

    final tombol = TombolUtama(teks: 'Daftar', onTap: _daftar);

    if (hp) {
      // HP: isian bisa digulir, tombol Daftar menempel di bawah.
      return Form(
        key: _kunci,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: isian,
                ),
              ),
            ),
            const SizedBox(height: 16),
            tombol,
            if (widget.penutup != null) widget.penutup!,
          ],
        ),
      );
    }

    // Web: semuanya berurutan ke bawah.
    return Form(
      key: _kunci,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...isian,
          const SizedBox(height: 18),
          tombol,
          if (widget.penutup != null) widget.penutup!,
        ],
      ),
    );
  }
}
