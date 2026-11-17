import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/store_profil.dart';
import '../../core/store_program.dart';
import '../../core/entri_tidur.dart';
import '../../shared/kartu_somniva.dart';
import '../../shared/tombol_somniva.dart';
import '../auth/login_page.dart';
import '../edukasi/edukasi_page.dart';
import '../ekspor/ekspor_page.dart';
import '../pengingat/pengingat_page.dart';
import 'bagian_profil.dart';
import '../tampilan/tampilan_page.dart';
import 'privasi_page.dart';

/// Tab Profil untuk HP (desain: Mobile App UI 20), tampil di dalam ShellMobile.
class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  void _buka(BuildContext context, Widget halaman) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => halaman));
  }

  void _keluar(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreProfil.instance,
      builder: (context, _) {
        final p = StoreProfil.instance;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.krim,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      p.inisial,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.nama,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          p.email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              KartuSomniva(
                radius: 30,
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 16),
                child: Row(
                  children: [
                    _angka('${p.targetJam} jam', 'Target tidur'),
                    _angka(
                      EntriTidur.formatJam(TimeOfDay(
                          hour: p.bangunMenit ~/ 60,
                          minute: p.bangunMenit % 60)),
                      'Jam bangun',
                    ),
                    _angka('Hari ${StoreProgram.instance.hariAktif}', 'Program'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              KartuSomniva(
                radius: 30,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Column(
                  children: [
                    BarisMenuProfil(
                      ikon: Icons.schedule_rounded,
                      teks: 'Target & jadwal tidur',
                      onTap: () => _buka(context, const UbahProfilPage()),
                    ),
                    BarisMenuProfil(
                      ikon: Icons.notifications_none_rounded,
                      teks: 'Pengingat',
                      onTap: () => _buka(context, const PengingatPage()),
                    ),
                    BarisMenuProfil(
                      ikon: Icons.file_download_outlined,
                      teks: 'Ekspor laporan',
                      onTap: () => _buka(context, const EksporPage()),
                    ),
                    BarisMenuProfil(
                      ikon: Icons.shield_outlined,
                      teks: 'Privasi data',
                      onTap: () => _buka(context, const PrivasiPage()),
                    ),
                    BarisMenuProfil(
                      ikon: Icons.nightlight_outlined,
                      teks: 'Mode gelap',
                      onTap: () => _buka(context, const TampilanPage()),
                    ),
                    BarisMenuProfil(
                      ikon: Icons.menu_book_outlined,
                      teks: 'Edukasi tidur',
                      onTap: () => _buka(context, const EdukasiPage()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TombolGaris(teks: 'Keluar', onTap: () => _keluar(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _angka(String nilai, String label) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ubah nama, email, jam bangun, dan target tidur di HP.
/// (Desain HP hanya menampilkan baris menunya; isinya mengikuti formulir web.)
class UbahProfilPage extends StatelessWidget {
  const UbahProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      TombolKembaliKotak(),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Target & jadwal tidur',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: AppColors.hijauGelap,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  KartuSomniva(
                    radius: 30,
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                    child: FormProfil(
                      tombolPenuh: true,
                      setelahSimpan: () => Navigator.of(context).pop(),
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
