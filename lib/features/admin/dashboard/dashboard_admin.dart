import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../shared/kartu_somniva.dart';
import '../widget/grafik_garis_admin.dart';
import '../widget/kartu_stat_admin.dart';
import '../widget/kepala_admin.dart';

/// Isi Dashboard Admin (desain: Website UI Admin 02 Dashboard Admin).
/// Hanya data agregat. Tidak ada isi jurnal atau skor pribadi pengguna.
class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const KepalaAdmin(
          kecil: 'Ringkasan aplikasi · data agregat',
          judul: 'Dashboard Admin',
        ),
        const SizedBox(height: 24),
        _statistik(),
        const SizedBox(height: 20),
        _grafikDanProgram(),
        const SizedBox(height: 20),
        _artikelPopuler(),
      ],
    );
  }

  // ---------- Empat kartu angka ----------
  Widget _statistik() {
    final kartu = <Widget>[
      KartuStatAdmin(
        label: 'Total pengguna',
        nilai: DataAdmin.ribuan(DataAdmin.totalPengguna),
        ket: '+${DataAdmin.ribuan(DataAdmin.penggunaBaruBulanIni)} bulan ini',
      ),
      KartuStatAdmin(
        label: 'Aktif 7 hari',
        nilai: DataAdmin.ribuan(DataAdmin.aktif7Hari),
        ket: '${DataAdmin.persenAktif}% dari total',
      ),
      KartuStatAdmin(
        label: 'Artikel terbit',
        nilai: '${DataAdmin.artikelTerbit}',
        ket: '${DataAdmin.artikelDraf} draf menunggu',
      ),
      KartuStatAdmin(
        label: 'Peserta program',
        nilai: DataAdmin.ribuan(DataAdmin.pesertaProgram),
        ket: '${DataAdmin.programTerbanyak} terbanyak',
      ),
    ];

    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= 1000) {
          return _baris(kartu);
        }
        return Column(
          children: [
            _baris(kartu.sublist(0, 2)),
            const SizedBox(height: 16),
            _baris(kartu.sublist(2, 4)),
          ],
        );
      },
    );
  }

  /// Beberapa kartu sebaris, sama lebar dan sama tinggi.
  Widget _baris(List<Widget> isi) {
    final anak = <Widget>[];
    for (var i = 0; i < isi.length; i++) {
      if (i > 0) anak.add(const SizedBox(width: 16));
      anak.add(Expanded(child: isi[i]));
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: anak,
      ),
    );
  }

  // ---------- Grafik pendaftar + penyelesaian program ----------
  Widget _grafikDanProgram() {
    final grafik = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _judulKartu('Pendaftar baru 7 hari'),
          const SizedBox(height: 14),
          GrafikGarisAdmin(
            nilai: DataAdmin.pendaftar7Hari,
            label: DataAdmin.labelHari7,
          ),
        ],
      ),
    );

    final program = KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _judulKartu('Penyelesaian Program 14 Hari'),
          const SizedBox(height: 12),
          for (final p in DataAdmin.penyelesaian) ...[
            _batang(p),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= 900) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: grafik),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: program),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [grafik, const SizedBox(height: 20), program],
        );
      },
    );
  }

  Widget _judulKartu(String teks) {
    return Text(
      teks,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.hijauGelap,
      ),
    );
  }

  Widget _batang(PenyelesaianProgram p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              p.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
            Text(
              '${p.persen}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 9,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Color(0xFFE3E9DA)),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: p.persen / 100,
                  child: const ColoredBox(color: AppColors.hijauSedang),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Artikel terpopuler ----------
  Widget _artikelPopuler() {
    final baris = <Widget>[];
    for (var i = 0; i < DataAdmin.artikelPopuler.length; i++) {
      final a = DataAdmin.artikelPopuler[i];
      baris.add(Container(
        height: 1,
        color: const Color(0xFFEFEADC),
      ));
      baris.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(
                a.judul,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                a.kategori,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${DataAdmin.ribuan(a.baca)} baca',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _judulKartu('Artikel terpopuler'),
          const SizedBox(height: 12),
          ...baris,
        ],
      ),
    );
  }
}
