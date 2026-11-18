import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../shared/kartu_somniva.dart';
import '../widget/komponen_admin.dart';
import '../widget/kepala_admin.dart';

/// Isi Manajemen Pengguna (desain: Website UI Admin 03).
/// Admin hanya melihat data akun. Catatan dan skor tidur pribadi tidak tampil.
class PenggunaAdmin extends StatefulWidget {
  const PenggunaAdmin({super.key});

  @override
  State<PenggunaAdmin> createState() => _PenggunaAdminState();
}

class _PenggunaAdminState extends State<PenggunaAdmin> {
  static const List<String> _opsiStatus = ['Semua', 'Aktif', 'Nonaktif'];

  // Lebar kolom (perbandingan).
  static const int _fNama = 6, _fEmail = 8, _fDaftar = 5, _fStatus = 4;
  static const int _fAksi = 8;

  String _status = 'Semua';
  String _kata = '';

  // ---------- Aksi ----------
  void _pesan(String teks) {
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

  Future<void> _ubahStatus(AkunPengguna a) async {
    if (a.aktif) {
      final ya = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Nonaktifkan akun?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.hijauGelap,
            ),
          ),
          content: Text(
            '${a.nama} tidak bisa masuk ke Somniva sampai akunnya diaktifkan kembali.',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.hijauGelap,
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.hijauTua,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Nonaktifkan',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );
      if (ya != true || !mounted) return;
      StorePenggunaAdmin.instance.ubahStatus(a.id, false);
      _pesan('Akun ${a.nama} dinonaktifkan.');
    } else {
      StorePenggunaAdmin.instance.ubahStatus(a.id, true);
      _pesan('Akun ${a.nama} diaktifkan kembali.');
    }
  }

  void _detail(AkunPengguna a) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.hijauPastel,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        a.inisial,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Detail akun',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _barisDetail('Nama', a.nama),
                _barisDetail('Email', a.email),
                _barisDetail('Terdaftar', DataAdmin.tanggalPendek(a.daftar)),
                _barisDetail(
                    'Terakhir masuk', DataAdmin.terakhirMasuk(a.hariLaluMasuk)),
                _barisDetail('Status', a.aktif ? 'Aktif' : 'Nonaktif'),
                const SizedBox(height: 6),
                const Text(
                  'Catatan dan skor tidur pribadi tidak ditampilkan.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TombolKecilAdmin(
                      teks: 'Tutup',
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                    const SizedBox(width: 10),
                    TombolKecilAdmin(
                      teks: a.aktif ? 'Nonaktifkan' : 'Aktifkan',
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _ubahStatus(a);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barisDetail(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tampilan ----------
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StorePenggunaAdmin.instance,
      builder: (context, _) {
        final hasil =
            StorePenggunaAdmin.instance.cari(status: _status, kata: _kata);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KepalaAdmin(
              kecil:
                  '${DataAdmin.ribuan(DataAdmin.totalPengguna)} akun terdaftar',
              judul: 'Manajemen Pengguna',
              aksi: [_kolomCari()],
            ),
            const SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: ChipFilterAdmin(
                opsi: _opsiStatus,
                terpilih: _status,
                onPilih: (s) => setState(() => _status = s),
              ),
            ),
            const SizedBox(height: 20),
            KartuSomniva(
              radius: 28,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
              child: _tabel(hasil),
            ),
            const SizedBox(height: 16),
            const Text(
              'Admin hanya melihat data akun. Catatan dan skor tidur pribadi tidak ditampilkan.',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _kolomCari() {
    OutlineInputBorder garis(Color warna, [double lebar = 1.2]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return SizedBox(
      width: 290,
      child: TextField(
        onChanged: (v) => setState(() => _kata = v),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.hijauGelap,
        ),
        decoration: InputDecoration(
          hintText: 'Cari nama atau email',
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9AA392),
          ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          enabledBorder: garis(AppColors.hijauPastel),
          focusedBorder: garis(AppColors.hijauSedang, 1.6),
        ),
      ),
    );
  }

  Widget _tabel(List<AkunPengguna> data) {
    return LayoutBuilder(
      builder: (context, box) {
        const lebarMin = 860.0;
        final lebar = box.maxWidth < lebarMin ? lebarMin : box.maxWidth;

        final isi = SizedBox(
          width: lebar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _kepalaTabel(),
              if (data.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 34),
                  child: Text(
                    'Tidak ada akun yang cocok. Coba kata kunci atau filter lain.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                )
              else
                for (final a in data) _barisAkun(a),
            ],
          ),
        );

        if (box.maxWidth >= lebarMin) return isi;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: isi,
        );
      },
    );
  }

  Widget _kepalaTabel() {
    Widget sel(String t, int flex) => Expanded(
          flex: flex,
          child: Text(
            t,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.teksSekunder,
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          sel('Nama', _fNama),
          sel('Email', _fEmail),
          sel('Terdaftar', _fDaftar),
          sel('Status', _fStatus),
          sel('Aksi', _fAksi),
        ],
      ),
    );
  }

  Widget _barisAkun(AkunPengguna a) {
    const teksIsi = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.hijauGelap,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEFEADC))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: _fNama,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                a.nama,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ),
          Expanded(
            flex: _fEmail,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                a.email,
                overflow: TextOverflow.ellipsis,
                style: teksIsi,
              ),
            ),
          ),
          Expanded(
            flex: _fDaftar,
            child: Text(DataAdmin.tanggalPendek(a.daftar), style: teksIsi),
          ),
          Expanded(
            flex: _fStatus,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LencanaStatusAdmin(
                teks: a.aktif ? 'Aktif' : 'Nonaktif',
                menonjol: a.aktif,
              ),
            ),
          ),
          Expanded(
            flex: _fAksi,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                TombolKecilAdmin(teks: 'Detail', onTap: () => _detail(a)),
                TombolKecilAdmin(
                  teks: a.aktif ? 'Nonaktifkan' : 'Aktifkan',
                  onTap: () => _ubahStatus(a),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
