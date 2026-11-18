import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../core/data_pengaturan_admin.dart';
import '../../../core/validator.dart';
import '../../../shared/kartu_somniva.dart';
import '../../../shared/kolom_teks_somniva.dart';
import '../../../shared/saklar_somniva.dart';
import '../widget/kepala_admin.dart';

/// Isi Pengaturan & Profil Admin (desain: Website UI Admin 06).
/// Kiri: profil admin (nama, email, kata sandi baru).
/// Kanan: pengaturan sistem dengan tiga saklar.
class PengaturanAdmin extends StatelessWidget {
  const PengaturanAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KepalaAdmin(
          kecil: 'Akun dan sistem',
          judul: 'Pengaturan & Profil Admin',
          aksi: const [],
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, box) {
            const kiri = _KartuProfilAdmin();
            const kanan = _KartuPengaturanSistem();
            if (box.maxWidth < 980) {
              return const Column(
                children: [kiri, SizedBox(height: 22), kanan],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: kiri),
                SizedBox(width: 24),
                Expanded(child: kanan),
              ],
            );
          },
        ),
      ],
    );
  }
}

void _pesan(BuildContext context, String teks) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(teks),
        behavior: SnackBarBehavior.floating,
        width: 420,
      ),
    );
}

// =============================================================================
// Profil admin
// =============================================================================

class _KartuProfilAdmin extends StatefulWidget {
  const _KartuProfilAdmin();

  @override
  State<_KartuProfilAdmin> createState() => _KartuProfilAdminState();
}

class _KartuProfilAdminState extends State<_KartuProfilAdmin> {
  final _kunci = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _email;
  final _sandiBaru = TextEditingController();
  bool _lihatSandi = false;

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: StoreAdmin.instance.nama);
    _email = TextEditingController(text: StoreAdmin.instance.email);
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _sandiBaru.dispose();
    super.dispose();
  }

  /// Kata sandi baru boleh kosong (artinya tidak diganti).
  String? _cekSandiBaru(String? v) {
    if (v == null || v.isEmpty) return null;
    return Validator.sandi(v);
  }

  void _simpan() {
    if (!_kunci.currentState!.validate()) return;
    final ganti = _sandiBaru.text.isNotEmpty;
    StoreAdmin.instance.simpanProfil(
      nama: _nama.text,
      email: _email.text,
      sandiBaru: _sandiBaru.text,
    );
    _sandiBaru.clear();
    _pesan(
      context,
      ganti
          ? 'Profil dan kata sandi admin disimpan.'
          : 'Profil admin disimpan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 28),
      child: Form(
        key: _kunci,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Profil admin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
            const SizedBox(height: 14),
            KolomTeks(
              label: 'Nama',
              controller: _nama,
              validator: Validator.nama,
              aksi: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            KolomTeks(
              label: 'Email',
              controller: _email,
              jenisKeyboard: TextInputType.emailAddress,
              validator: Validator.email,
              aksi: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            KolomTeks(
              label: 'Kata sandi baru',
              controller: _sandiBaru,
              hint: 'Kosongkan jika tidak diganti',
              sembunyikan: !_lihatSandi,
              validator: _cekSandiBaru,
              aksi: TextInputAction.done,
              onSubmitted: (_) => _simpan(),
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
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: _simpan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.hijauTua,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Simpan perubahan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Pengaturan sistem
// =============================================================================

class _KartuPengaturanSistem extends StatelessWidget {
  const _KartuPengaturanSistem();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StorePengaturanAdmin.instance,
      builder: (context, _) {
        final s = StorePengaturanAdmin.instance;

        void kabari(String teks) => _pesan(context, teks);

        return KartuSomniva(
          radius: 28,
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pengaturan sistem',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.hijauGelap,
                ),
              ),
              const SizedBox(height: 14),
              _barisSaklar(
                judul: 'Pendaftaran pengguna baru',
                ket: 'Izinkan akun baru mendaftar',
                nilai: s.pendaftaranBuka,
                onUbah: (v) {
                  s.ubahPendaftaran(v);
                  kabari(v ? 'Pendaftaran dibuka.' : 'Pendaftaran ditutup.');
                },
              ),
              _barisSaklar(
                judul: 'Notifikasi email ke admin',
                ket: 'Ringkasan mingguan',
                nilai: s.notifikasiEmail,
                onUbah: (v) {
                  s.ubahNotifikasi(v);
                  kabari(v
                      ? 'Notifikasi email dinyalakan.'
                      : 'Notifikasi email dimatikan.');
                },
              ),
              _barisSaklar(
                judul: 'Mode pemeliharaan',
                ket: 'Tampilkan pengumuman di aplikasi',
                nilai: s.pemeliharaan,
                onUbah: (v) {
                  s.ubahPemeliharaan(v);
                  kabari(v
                      ? 'Mode pemeliharaan diaktifkan.'
                      : 'Mode pemeliharaan dimatikan.');
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Perubahan pengaturan dicatat dan bisa ditinjau oleh admin lain.',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              if (s.catatan.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Perubahan terakhir',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 6),
                for (final c in s.catatan.take(3))
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            c.teks,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.hijauGelap,
                            ),
                          ),
                        ),
                        Text(
                          c.jam,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _barisSaklar({
    required String judul,
    required String ket,
    required bool nilai,
    required ValueChanged<bool> onUbah,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ket,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SaklarSomniva(nilai: nilai, onUbah: onUbah),
        ],
      ),
    );
  }
}
