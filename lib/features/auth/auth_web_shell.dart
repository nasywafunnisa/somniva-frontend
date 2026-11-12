import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'ilustrasi_gelombang.dart';

/// Kerangka halaman Masuk/Daftar untuk tampilan WEB (layar lebar):
/// panel hijau di kiri, formulir di kanan. Dipakai ulang oleh Registrasi.
class AuthWebShell extends StatelessWidget {
  /// 0 = tab Masuk aktif, 1 = tab Daftar aktif.
  final int tabAktif;
  final VoidCallback onMasuk;
  final VoidCallback onDaftar;
  final String judul;
  final String subjudul;
  final Widget form;

  const AuthWebShell({
    super.key,
    required this.tabAktif,
    required this.onMasuk,
    required this.onDaftar,
    required this.judul,
    required this.subjudul,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Row(
        children: [
          const Expanded(flex: 51, child: _PanelKiri()),
          Expanded(flex: 49, child: _PanelKanan(shell: this)),
        ],
      ),
    );
  }
}

class _PanelKiri extends StatelessWidget {
  const _PanelKiri();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.hijauPastel,
      child: LayoutBuilder(
        builder: (context, box) {
          final judulUkuran = (box.maxWidth * 0.075).clamp(34.0, 58.0);
          final tampilGambar = box.maxHeight >= 640;
          return Stack(
            children: [
              // Logo kecil di kiri atas
              Positioned(
                left: 54,
                top: 50,
                child: Row(
                  children: const [
                    _BulanKecil(),
                    SizedBox(width: 14),
                    Text(
                      'Somniva',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ],
                ),
              ),
              // Teks utama
              Align(
                alignment: const Alignment(0, -0.28),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 54),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kenali pola tidurmu,\nperbaiki kebiasaannya.',
                        style: TextStyle(
                          fontSize: judulUkuran,
                          fontWeight: FontWeight.w800,
                          height: 1.12,
                          letterSpacing: -1,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Catat kebiasaan harian, lihat hubungannya dengan kualitas tidur, lalu ikuti program 14 hari yang terarah.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _Poin('Sleep Score dan Sleep Debt yang mudah dibaca'),
                      const _Poin(
                          'Analisis hubungan kafein, stres, dan layar'),
                      const _Poin('Rekomendasi waktu tidur yang personal'),
                    ],
                  ),
                ),
              ),
              if (tampilGambar)
                const Positioned(
                  left: 54,
                  right: 100,
                  bottom: 70,
                  height: 90,
                  child: IlustrasiGelombang(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BulanKecil extends StatelessWidget {
  const _BulanKecil();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.nightlight_round,
      size: 26,
      color: AppColors.hijauSedang,
    );
  }
}

class _Poin extends StatelessWidget {
  final String teks;
  const _Poin(this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '•  $teks',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.hijauGelap,
        ),
      ),
    );
  }
}

class _PanelKanan extends StatelessWidget {
  final AuthWebShell shell;
  const _PanelKanan({required this.shell});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.krimTerang,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol mode gelap (tampilan saja dulu)
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: AppColors.krim,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Mode gelap akan ditambahkan nanti.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.dark_mode_outlined,
                          size: 20,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _Tab(
                  aktif: shell.tabAktif,
                  onMasuk: shell.onMasuk,
                  onDaftar: shell.onDaftar,
                ),
                const SizedBox(height: 24),
                Text(
                  shell.judul,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  shell.subjudul,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 20),
                shell.form,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final int aktif;
  final VoidCallback onMasuk;
  final VoidCallback onDaftar;
  const _Tab({
    required this.aktif,
    required this.onMasuk,
    required this.onDaftar,
  });

  Widget _item(String teks, bool pilih, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: pilih ? AppColors.hijauTua : Colors.transparent,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Text(
            teks,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: pilih ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.krim,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          _item('Masuk', aktif == 0, onMasuk),
          _item('Daftar', aktif == 1, onDaftar),
        ],
      ),
    );
  }
}
