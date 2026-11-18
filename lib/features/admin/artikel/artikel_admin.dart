import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_artikel_admin.dart';
import '../../../shared/kartu_somniva.dart';
import '../widget/kepala_admin.dart';
import '../widget/komponen_admin.dart';

const Color _garis = Color(0xFFEFEADC);

/// Isi Manajemen Artikel & Edukasi (desain: Website UI Admin 04).
/// Kiri: daftar artikel dengan filter Semua/Terbit/Draf.
/// Kanan: Editor cepat untuk menulis atau mengubah artikel.
class ArtikelAdmin extends StatefulWidget {
  const ArtikelAdmin({super.key});

  @override
  State<ArtikelAdmin> createState() => _ArtikelAdminState();
}

class _ArtikelAdminState extends State<ArtikelAdmin> {
  static const List<String> _opsiStatus = ['Semua', 'Terbit', 'Draf'];

  // Lebar kolom tabel (perbandingan).
  static const int _fJudul = 11, _fKategori = 5, _fStatus = 4, _fAksi = 7;

  final _judul = TextEditingController();
  final _isi = TextEditingController();
  final _fokusJudul = FocusNode();

  String _status = 'Semua';
  String _kategori = StoreArtikelAdmin.kategori.first;
  int? _idDiubah; // null = artikel baru
  String? _salahJudul;
  String? _salahIsi;

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    _fokusJudul.dispose();
    super.dispose();
  }

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

  void _kosongkanEditor() {
    _judul.clear();
    _isi.clear();
    _kategori = StoreArtikelAdmin.kategori.first;
    _idDiubah = null;
    _salahJudul = null;
    _salahIsi = null;
  }

  void _baru() {
    setState(_kosongkanEditor);
    _fokusJudul.requestFocus();
  }

  void _ubah(ArtikelKelola a) {
    setState(() {
      _judul.text = a.judul;
      _isi.text = a.isi;
      _kategori = a.kategori;
      _idDiubah = a.id;
      _salahJudul = null;
      _salahIsi = null;
    });
    _fokusJudul.requestFocus();
  }

  void _simpan({required bool terbit}) {
    final judul = _judul.text.trim();
    final isi = _isi.text.trim();

    final salahJudul = judul.length < 5 ? 'Judul minimal 5 karakter.' : null;
    final salahIsi = isi.length < 20 ? 'Isi artikel minimal 20 karakter.' : null;
    if (salahJudul != null || salahIsi != null) {
      setState(() {
        _salahJudul = salahJudul;
        _salahIsi = salahIsi;
      });
      return;
    }

    final sedangUbah = _idDiubah != null;
    StoreArtikelAdmin.instance.simpan(
      id: _idDiubah,
      judul: judul,
      kategoriArtikel: _kategori,
      isi: isi,
      terbit: terbit,
    );
    setState(_kosongkanEditor);

    if (terbit) {
      _pesan(sedangUbah ? 'Perubahan diterbitkan.' : 'Artikel diterbitkan.');
    } else {
      _pesan(sedangUbah ? 'Perubahan disimpan sebagai draf.' : 'Draf disimpan.');
    }
  }

  Future<void> _hapus(ArtikelKelola a) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Hapus artikel?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
        content: Text(
          '"${a.judul}" akan dihapus dan tidak tampil lagi di Edukasi Tidur. Tindakan ini tidak bisa dibatalkan.',
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
            style: TextButton.styleFrom(foregroundColor: AppColors.hijauGelap),
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
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (ya != true || !mounted) return;

    StoreArtikelAdmin.instance.hapus(a.id);
    if (_idDiubah == a.id) setState(_kosongkanEditor);
    _pesan('Artikel dihapus.');
  }

  // ---------- Tampilan ----------
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreArtikelAdmin.instance,
      builder: (context, _) {
        final s = StoreArtikelAdmin.instance;
        final hasil = s.cari(status: _status);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KepalaAdmin(
              kecil: '${s.jumlahTerbit} terbit · ${s.jumlahDraf} draf',
              judul: 'Artikel & Materi Edukasi',
              aksi: [_tombolBaru()],
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, box) {
                final kiri = _kartuDaftar(hasil);
                final kanan = _kartuEditor();
                if (box.maxWidth < 980) {
                  return Column(
                    children: [kiri, const SizedBox(height: 22), kanan],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 62, child: kiri),
                    const SizedBox(width: 24),
                    Expanded(flex: 38, child: kanan),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tombolBaru() {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: _baru,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.hijauTua,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: const Text(
          'Artikel baru',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ---------- Kartu daftar ----------
  Widget _kartuDaftar(List<ArtikelKelola> data) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ChipFilterAdmin(
              opsi: _opsiStatus,
              terpilih: _status,
              onPilih: (v) => setState(() => _status = v),
            ),
          ),
          const SizedBox(height: 18),
          _tabel(data),
        ],
      ),
    );
  }

  Widget _tabel(List<ArtikelKelola> data) {
    return LayoutBuilder(
      builder: (context, box) {
        const lebarMin = 640.0;
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
                    'Belum ada artikel di kategori ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                )
              else
                for (final a in data) _barisArtikel(a),
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

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: Row(
        children: [
          sel('Judul', _fJudul),
          sel('Kategori', _fKategori),
          sel('Status', _fStatus),
          sel('Aksi', _fAksi),
        ],
      ),
    );
  }

  Widget _barisArtikel(ArtikelKelola a) {
    final sedangDiubah = a.id == _idDiubah;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: sedangDiubah
            ? AppColors.hijauPastel.withAlpha(60)
            : Colors.transparent,
        border: const Border(top: BorderSide(color: _garis)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: _fJudul,
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                a.judul,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ),
          Expanded(
            flex: _fKategori,
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
            flex: _fStatus,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LencanaStatusAdmin(
                teks: a.terbit ? 'Terbit' : 'Draf',
                menonjol: a.terbit,
              ),
            ),
          ),
          Expanded(
            flex: _fAksi,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                TombolKecilAdmin(teks: 'Ubah', onTap: () => _ubah(a)),
                TombolKecilAdmin(teks: 'Hapus', onTap: () => _hapus(a)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Editor cepat ----------
  Widget _kartuEditor() {
    final sedangUbah = _idDiubah != null;

    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  sedangUbah ? 'Ubah artikel' : 'Editor cepat',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.hijauGelap,
                  ),
                ),
              ),
              if (sedangUbah)
                TextButton(
                  onPressed: () => setState(_kosongkanEditor),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.teksSekunder,
                  ),
                  child: const Text(
                    'Batal ubah',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _label('Judul'),
          const SizedBox(height: 8),
          _kolom(
            controller: _judul,
            fokus: _fokusJudul,
            hint: 'Contoh: Panduan pernapasan 4–7–8',
            galat: _salahJudul,
            onUbah: (_) {
              if (_salahJudul != null) setState(() => _salahJudul = null);
            },
          ),
          const SizedBox(height: 16),
          ChipFilterAdmin(
            opsi: StoreArtikelAdmin.kategori,
            terpilih: _kategori,
            onPilih: (k) => setState(() => _kategori = k),
          ),
          const SizedBox(height: 16),
          _label('Isi artikel'),
          const SizedBox(height: 8),
          _kolom(
            controller: _isi,
            hint: 'Tulis langkah atau penjelasan singkat di sini...',
            garisMin: 7,
            garisMaks: 7,
            galat: _salahIsi,
            onUbah: (_) {
              if (_salahIsi != null) setState(() => _salahIsi = null);
            },
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: () => _simpan(terbit: true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.hijauTua,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Terbitkan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => _simpan(terbit: false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.hijauGelap,
                side: const BorderSide(color: AppColors.hijauSedang, width: 1.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Simpan draf',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String teks) {
    return Text(
      teks,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: AppColors.hijauGelap,
      ),
    );
  }

  Widget _kolom({
    required TextEditingController controller,
    required String hint,
    FocusNode? fokus,
    int garisMin = 1,
    int garisMaks = 1,
    String? galat,
    ValueChanged<String>? onUbah,
  }) {
    OutlineInputBorder garis(Color warna, [double lebar = 1.2]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(garisMaks > 1 ? 22 : 20),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return TextField(
      controller: controller,
      focusNode: fokus,
      onChanged: onUbah,
      minLines: garisMin,
      maxLines: garisMaks,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.hijauGelap,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9AA392),
        ),
        errorText: galat,
        errorStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFB3563F),
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        enabledBorder: garis(_garis, 1.5),
        focusedBorder: garis(AppColors.hijauSedang, 1.8),
        errorBorder: garis(const Color(0xFFB3563F), 1.5),
        focusedErrorBorder: garis(const Color(0xFFB3563F), 1.8),
      ),
    );
  }
}
