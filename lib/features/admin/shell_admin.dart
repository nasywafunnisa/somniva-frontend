import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/data_admin.dart';
import '../../shared/halaman_segera.dart';
import '../../shared/logo_somniva.dart';
import 'artikel/artikel_admin.dart';
import 'auth/login_admin_page.dart';
import 'dashboard/dashboard_admin.dart';
import 'pengaturan/pengaturan_admin.dart';
import 'pengguna/pengguna_admin.dart';
import 'program/program_admin.dart';

class _MenuAdmin {
  final String nama;
  final IconData ikon;
  const _MenuAdmin(this.nama, this.ikon);
}

/// Kerangka WEB ADMIN setelah login: sidebar kiri + isi halaman di kanan.
/// Pola sama dengan ShellWeb milik pengguna.
class ShellAdmin extends StatefulWidget {
  const ShellAdmin({super.key});

  @override
  State<ShellAdmin> createState() => _ShellAdminState();
}

class _ShellAdminState extends State<ShellAdmin> {
  int _terpilih = 0;

  static const List<_MenuAdmin> _menu = [
    _MenuAdmin('Dashboard', Icons.home_outlined),
    _MenuAdmin('Pengguna', Icons.people_outline_rounded),
    _MenuAdmin('Artikel & Edukasi', Icons.article_outlined),
    _MenuAdmin('Program Tidur', Icons.check_rounded),
    _MenuAdmin('Pengaturan', Icons.tune_rounded),
  ];

  void _keluar() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginAdminPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: Row(
        children: [
          _sidebar(),
          Expanded(child: _isi()),
        ],
      ),
    );
  }

  Widget _isi() {
    Widget gulir(Widget anak) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 36, 40, 40),
          child: anak,
        );

    switch (_terpilih) {
      case 0:
        return gulir(const DashboardAdmin());
      case 1:
        return gulir(const PenggunaAdmin());
      case 2:
        return gulir(const ArtikelAdmin());
      case 3:
        return gulir(const ProgramAdmin());
      case 4:
        return gulir(const PengaturanAdmin());
      default:
        // Halaman lain dibuat di langkah berikutnya.
        return HalamanSegera(judul: _menu[_terpilih].nama);
    }
  }

  Widget _sidebar() {
    return Container(
      width: 252,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const IkonBulan(ukuran: 34),
                const SizedBox(width: 10),
                const Text(
                  'Somniva',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.hijauGelap,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.krim,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView.separated(
              itemCount: _menu.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, i) => _itemMenu(i),
            ),
          ),
          _kartuAdmin(),
        ],
      ),
    );
  }

  Widget _itemMenu(int i) {
    final aktif = i == _terpilih;
    final m = _menu[i];
    return Material(
      color: aktif ? AppColors.hijauPastel : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _terpilih = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(
                m.ikon,
                size: 21,
                color: aktif ? AppColors.hijauGelap : AppColors.teksSekunder,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  m.nama,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: aktif ? FontWeight.w700 : FontWeight.w500,
                    color:
                        aktif ? AppColors.hijauGelap : AppColors.teksSekunder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kartuAdmin() {
    return ListenableBuilder(
      listenable: StoreAdmin.instance,
      builder: (context, _) => Material(
        color: AppColors.krim,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.hijauPastel,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  StoreAdmin.instance.inisial,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StoreAdmin.instance.nama,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.hijauGelap,
                      ),
                    ),
                    GestureDetector(
                      onTap: _keluar,
                      child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          'Keluar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
