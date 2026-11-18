import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/entri_tidur.dart';
import '../../core/laporan_tidur.dart';
import '../../core/store_profil.dart';
import '../../core/store_tidur.dart';
import '../../core/validator.dart';
import '../../shared/kolom_teks_somniva.dart';
import '../../shared/saklar_somniva.dart';
import '../../shared/util.dart';
import '../auth/login_page.dart';
import '../ekspor/bagian_ekspor.dart';

const Color _cokeltTua = Color(0xFF8A5A36);

void _pesan(BuildContext context, String teks) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(behavior: SnackBarBehavior.floating, content: Text(teks)),
  );
}

/// Formulir Profil & target tidur: nama, email, jam bangun, target 7/8/9 jam.
class FormProfil extends StatefulWidget {
  /// true = tombol Simpan selebar kolom (HP). false = tombol ringkas (web).
  final bool tombolPenuh;
  final VoidCallback? setelahSimpan;

  const FormProfil({super.key, this.tombolPenuh = false, this.setelahSimpan});

  @override
  State<FormProfil> createState() => _FormProfilState();
}

class _FormProfilState extends State<FormProfil> {
  final _kunci = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _email;
  late int _bangun;
  late int _target;

  @override
  void initState() {
    super.initState();
    final p = StoreProfil.instance;
    _nama = TextEditingController(text: p.nama);
    _email = TextEditingController(text: p.email);
    _bangun = p.bangunMenit;
    _target = p.targetJam;
  }

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    super.dispose();
  }

  String get _jamTeks => EntriTidur.formatJam(
      TimeOfDay(hour: _bangun ~/ 60, minute: _bangun % 60));

  Future<void> _pilihBangun() async {
    final t = await pilihJam(
      context,
      TimeOfDay(hour: _bangun ~/ 60, minute: _bangun % 60),
      judul: 'Jam bangun',
    );
    if (t != null) setState(() => _bangun = t.hour * 60 + t.minute);
  }

  void _simpan() {
    if (!_kunci.currentState!.validate()) return;
    StoreProfil.instance.simpanProfil(
      nama: _nama.text,
      email: _email.text,
      bangunMenit: _bangun,
      targetJam: _target,
    );
    _pesan(context, 'Perubahan disimpan.');
    widget.setelahSimpan?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _kunci,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KolomTeks(
            label: 'Nama',
            controller: _nama,
            validator: Validator.nama,
            aksi: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          KolomTeks(
            label: 'Email',
            controller: _email,
            jenisKeyboard: TextInputType.emailAddress,
            validator: Validator.email,
            aksi: TextInputAction.next,
          ),
          const SizedBox(height: 14),
          const Text(
            'Jam bangun',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.hijauGelap,
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _pilihBangun,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.hijauPastel, width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _jamTeks,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                    const Icon(Icons.schedule_rounded,
                        size: 20, color: AppColors.teksSekunder),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              const Text(
                'Target tidur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
              for (final j in const [7, 8, 9]) _chipTarget(j),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: widget.tombolPenuh ? double.infinity : null,
              height: 54,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.hijauTua,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
                child: const Text(
                  'Simpan perubahan',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipTarget(int jam) {
    final aktif = jam == _target;
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => setState(() => _target = jam),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Text(
            '$jam jam',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tiga saklar izin penggunaan data.
class DaftarIzinData extends StatelessWidget {
  const DaftarIzinData({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreProfil.instance,
      builder: (context, _) {
        final p = StoreProfil.instance;
        return Column(
          children: [
            _baris('Simpan riwayat tidur', 'Dipakai untuk grafik dan skor',
                p.simpanRiwayat,
                (v) => p.ubahIzin(simpanRiwayat: v)),
            _baris('Analisis korelasi', 'Hubungan kebiasaan dan skor',
                p.analisisKorelasi,
                (v) => p.ubahIzin(analisisKorelasi: v)),
            _baris('Rekomendasi pribadi', 'Waktu tidur dan program',
                p.rekomendasiPribadi,
                (v) => p.ubahIzin(rekomendasiPribadi: v)),
          ],
        );
      },
    );
  }

  Widget _baris(
      String judul, String ket, bool nilai, ValueChanged<bool> onUbah) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SaklarSomniva(nilai: nilai, onUbah: onUbah),
        ],
      ),
    );
  }
}

/// Tombol "Hapus akun & semua data" (gaya sama dengan TombolGarisKecil).
class TombolHapusAkun extends StatelessWidget {
  const TombolHapusAkun({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: () => AksiPrivasi.hapusAkun(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hijauGelap,
          side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Hapus akun & semua data',
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Aksi di halaman Privasi: unduh data, hapus riwayat, hapus akun.
class AksiPrivasi {
  AksiPrivasi._();

  static Future<bool> _konfirmasi(
    BuildContext context, {
    required String judul,
    required String isi,
    required String tombol,
  }) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          judul,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
        content: Text(
          isi,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            height: 1.45,
            color: AppColors.teksSekunder,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal',
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.hijauGelap)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(tombol,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: _cokeltTua)),
          ),
        ],
      ),
    );
    return ya ?? false;
  }

  /// "Unduh data saya" = PDF berisi semua bagian untuk 30 hari terakhir.
  static Future<void> unduhData(BuildContext context) {
    return AksiEkspor.unduh(
        context, RentangLaporan.tigaPuluhHari, const IsiLaporan());
  }

  static Future<void> hapusRiwayat(BuildContext context) async {
    final ya = await _konfirmasi(
      context,
      judul: 'Hapus riwayat tidur?',
      isi:
          'Catatan jurnal yang kamu isi akan dihapus. Data contoh bawaan tetap ada sampai database dibuat. Tindakan ini tidak bisa dibatalkan.',
      tombol: 'Hapus',
    );
    if (!ya || !context.mounted) return;
    StoreTidur.instance.hapusCatatanSaya();
    _pesan(context, 'Catatan jurnalmu sudah dihapus.');
  }

  static Future<void> hapusAkun(BuildContext context) async {
    final ya = await _konfirmasi(
      context,
      judul: 'Hapus akun & semua data?',
      isi:
          'Akun dan semua data yang kamu isi akan dihapus, lalu kamu kembali ke halaman masuk. Tindakan ini tidak bisa dibatalkan.',
      tombol: 'Hapus akun',
    );
    if (!ya || !context.mounted) return;
    StoreTidur.instance.hapusCatatanSaya();
    StoreProfil.instance.reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

/// Tombol "Unduh data saya" / "Hapus riwayat tidur" bergaya garis (web).
class TombolGarisKecil extends StatelessWidget {
  final String teks;
  final VoidCallback onTap;
  const TombolGarisKecil({super.key, required this.teks, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hijauGelap,
          side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
          padding: const EdgeInsets.symmetric(horizontal: 26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        child: Text(
          teks,
          style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Satu baris menu dengan kotak ikon hijau dan panah (HP).
class BarisMenuProfil extends StatelessWidget {
  final IconData ikon;
  final String teks;
  final VoidCallback onTap;

  const BarisMenuProfil({
    super.key,
    required this.ikon,
    required this.teks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.hijauPastel,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(ikon, size: 22, color: AppColors.hijauGelap),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                teks,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 26, color: AppColors.hijauGelap),
          ],
        ),
      ),
    );
  }
}

/// Tombol kembali kotak krim (dipakai halaman HP yang dibuka di atas tab).
class TombolKembaliKotak extends StatelessWidget {
  const TombolKembaliKotak({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.krim,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pop(),
        child: const SizedBox(
          width: 46,
          height: 46,
          child: Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: AppColors.hijauGelap),
        ),
      ),
    );
  }
}
