import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/data_admin.dart';
import '../../../core/data_program_admin.dart';
import '../../../shared/kartu_somniva.dart';
import '../widget/kepala_admin.dart';
import '../widget/komponen_admin.dart';

const Color _garis = Color(0xFFEFEADC);

/// Isi Manajemen Program (desain: Website UI Admin 05).
/// Kiri: daftar program (pilih satu). Kanan: tugas harian program yang dipilih.
class ProgramAdmin extends StatefulWidget {
  const ProgramAdmin({super.key});

  @override
  State<ProgramAdmin> createState() => _ProgramAdminState();
}

class _ProgramAdminState extends State<ProgramAdmin> {
  int? _idTerpilih;

  @override
  void initState() {
    super.initState();
    final semua = StoreProgramAdmin.instance.semua;
    _idTerpilih = semua.isEmpty ? null : semua.first.id;
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

  Future<void> _programBaru() async {
    final hasil = await showDialog<_HasilDialog>(
      context: context,
      builder: (_) => const _DialogTeks(
        judul: 'Program baru',
        label: 'Nama program',
        hint: 'Contoh: Tidur Nyenyak 21 Hari',
        tombol: 'Buat program',
        minimal: 3,
        pesanMinimal: 'Nama program minimal 3 karakter.',
      ),
    );
    if (hasil == null || hasil.teks == null || !mounted) return;
    final baru = StoreProgramAdmin.instance.buat(hasil.teks!);
    setState(() => _idTerpilih = baru.id);
    _pesan('Program dibuat sebagai draf. Tambahkan tugas hariannya.');
  }

  Future<void> _ubahNama(ProgramKelola p) async {
    final hasil = await showDialog<_HasilDialog>(
      context: context,
      builder: (_) => _DialogTeks(
        judul: 'Ubah nama program',
        label: 'Nama program',
        awal: p.nama,
        tombol: 'Simpan',
        minimal: 3,
        pesanMinimal: 'Nama program minimal 3 karakter.',
      ),
    );
    if (hasil == null || hasil.teks == null || !mounted) return;
    StoreProgramAdmin.instance.ubahNama(p.id, hasil.teks!);
    _pesan('Nama program diperbarui.');
  }

  void _ubahStatus(ProgramKelola p, StatusProgram status) {
    StoreProgramAdmin.instance.ubahStatus(p.id, status);
    _pesan('"${p.nama}" sekarang ${status.label.toLowerCase()}.');
  }

  Future<void> _hapusProgram(ProgramKelola p) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Hapus program?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.hijauGelap,
          ),
        ),
        content: Text(
          p.peserta > 0
              ? '"${p.nama}" punya ${DataAdmin.ribuan(p.peserta)} peserta. Programnya dihapus beserta semua tugas hariannya. Tindakan ini tidak bisa dibatalkan.'
              : '"${p.nama}" dihapus beserta semua tugas hariannya. Tindakan ini tidak bisa dibatalkan.',
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

    StoreProgramAdmin.instance.hapus(p.id);
    if (_idTerpilih == p.id) {
      final sisa = StoreProgramAdmin.instance.semua;
      setState(() => _idTerpilih = sisa.isEmpty ? null : sisa.first.id);
    }
    _pesan('Program dihapus.');
  }

  Future<void> _tambahTugas(ProgramKelola p) async {
    if (p.tugas.length >= StoreProgramAdmin.maksTugas) {
      _pesan('Satu program maksimal ${StoreProgramAdmin.maksTugas} tugas harian.');
      return;
    }
    final hasil = await showDialog<_HasilDialog>(
      context: context,
      builder: (_) => _DialogTeks(
        judul: 'Tambah tugas · Hari ${p.tugas.length + 1}',
        label: 'Tugas harian',
        hint: 'Contoh: Matikan layar 45 menit sebelum tidur',
        tombol: 'Tambah',
        minimal: 5,
        pesanMinimal: 'Tugas minimal 5 karakter.',
      ),
    );
    if (hasil == null || hasil.teks == null || !mounted) return;
    StoreProgramAdmin.instance.tambahTugas(p.id, hasil.teks!);
    _pesan('Tugas hari ${p.tugas.length + 1} ditambahkan.');
  }

  Future<void> _ubahTugas(ProgramKelola p, TugasProgram t) async {
    final hasil = await showDialog<_HasilDialog>(
      context: context,
      builder: (_) => _DialogTeks(
        judul: 'Ubah tugas · Hari ${t.hari}',
        label: 'Tugas harian',
        awal: t.teks,
        tombol: 'Simpan',
        minimal: 5,
        pesanMinimal: 'Tugas minimal 5 karakter.',
        tombolHapus: 'Hapus tugas',
      ),
    );
    if (hasil == null || !mounted) return;
    if (hasil.hapus) {
      StoreProgramAdmin.instance.hapusTugas(p.id, t.hari);
      _pesan('Tugas hari ${t.hari} dihapus. Hari sesudahnya bergeser naik.');
    } else if (hasil.teks != null) {
      StoreProgramAdmin.instance.ubahTugas(p.id, t.hari, hasil.teks!);
      _pesan('Tugas hari ${t.hari} diperbarui.');
    }
  }

  // ---------- Tampilan ----------
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StoreProgramAdmin.instance,
      builder: (context, _) {
        final semua = StoreProgramAdmin.instance.semua;
        final terpilih =
            _idTerpilih == null ? null : StoreProgramAdmin.instance.ambil(_idTerpilih!);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KepalaAdmin(
              kecil: 'Program peningkatan tidur',
              judul: 'Manajemen Program',
              aksi: [_tombolBaru()],
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, box) {
                final kiri = _kartuDaftar(semua, terpilih);
                final kanan = _kartuTugas(terpilih);
                if (box.maxWidth < 980) {
                  return Column(
                    children: [kiri, const SizedBox(height: 22), kanan],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: kiri),
                    const SizedBox(width: 24),
                    Expanded(child: kanan),
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
        onPressed: _programBaru,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.hijauTua,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: const Text(
          'Program baru',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ---------- Kartu daftar program ----------
  Widget _kartuDaftar(List<ProgramKelola> semua, ProgramKelola? terpilih) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Text(
              'Daftar program',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          if (semua.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 34),
              child: Text(
                'Belum ada program. Tekan "Program baru" untuk membuat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            )
          else
            for (final p in semua) _barisProgram(p, p.id == terpilih?.id),
        ],
      ),
    );
  }

  Widget _barisProgram(ProgramKelola p, bool dipilih) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: Material(
        color: dipilih ? AppColors.hijauPastel.withAlpha(60) : Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _idTerpilih = p.id),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 14, 0, 14),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      p.nama,
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
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: LencanaStatusAdmin(
                      teks: p.status.label,
                      menonjol: p.status == StatusProgram.aktif,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    '${DataAdmin.ribuan(p.peserta)} peserta',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hijauGelap,
                    ),
                  ),
                ),
                _menuProgram(p),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuProgram(ProgramKelola p) {
    return PopupMenuButton<String>(
      tooltip: 'Aksi program',
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.more_horiz_rounded,
          size: 22, color: AppColors.teksSekunder),
      onSelected: (v) {
        switch (v) {
          case 'aktif':
            _ubahStatus(p, StatusProgram.aktif);
          case 'draf':
            _ubahStatus(p, StatusProgram.draf);
          case 'nonaktif':
            _ubahStatus(p, StatusProgram.nonaktif);
          case 'nama':
            _ubahNama(p);
          case 'hapus':
            _hapusProgram(p);
        }
      },
      itemBuilder: (_) => [
        if (p.status != StatusProgram.aktif)
          _itemMenu('aktif', 'Aktifkan'),
        if (p.status != StatusProgram.draf)
          _itemMenu('draf', 'Jadikan draf'),
        if (p.status != StatusProgram.nonaktif)
          _itemMenu('nonaktif', 'Nonaktifkan'),
        _itemMenu('nama', 'Ubah nama'),
        _itemMenu('hapus', 'Hapus program'),
      ],
    );
  }

  PopupMenuItem<String> _itemMenu(String nilai, String teks) {
    return PopupMenuItem<String>(
      value: nilai,
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: AppColors.hijauGelap,
        ),
      ),
    );
  }

  // ---------- Kartu tugas harian ----------
  Widget _kartuTugas(ProgramKelola? p) {
    return KartuSomniva(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              p == null ? 'Tugas harian' : 'Tugas harian · ${p.nama}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          if (p == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 34),
              child: Text(
                'Pilih sebuah program untuk melihat tugas hariannya.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.teksSekunder,
                ),
              ),
            )
          else ...[
            if (p.tugas.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Belum ada tugas. Tekan "Tambah tugas" untuk menyusun hari pertama.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksSekunder,
                  ),
                ),
              )
            else
              for (final t in p.tugas) _barisTugas(p, t),
            const SizedBox(height: 18),
            SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: () => _tambahTugas(p),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.hijauGelap,
                  side: const BorderSide(
                      color: AppColors.hijauSedang, width: 1.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Tambah tugas',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _barisTugas(ProgramKelola p, TugasProgram t) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _garis)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              'Hari ${t.hari}',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.hijauGelap,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                t.teks,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ),
          TombolKecilAdmin(teks: 'Ubah', onTap: () => _ubahTugas(p, t)),
        ],
      ),
    );
  }
}

/// Hasil dialog teks: [teks] terisi kalau disimpan, [hapus] true kalau
/// tombol hapus ditekan. Dialog ditutup tanpa hasil (null) kalau dibatalkan.
class _HasilDialog {
  final String? teks;
  final bool hapus;
  const _HasilDialog.simpan(String this.teks) : hapus = false;
  const _HasilDialog.hapus()
      : teks = null,
        hapus = true;
}

/// Dialog satu kolom teks (nama program atau tugas harian).
class _DialogTeks extends StatefulWidget {
  final String judul;
  final String label;
  final String hint;
  final String awal;
  final String tombol;
  final int minimal;
  final String pesanMinimal;
  final String? tombolHapus;

  const _DialogTeks({
    required this.judul,
    required this.label,
    required this.tombol,
    required this.minimal,
    required this.pesanMinimal,
    this.hint = '',
    this.awal = '',
    this.tombolHapus,
  });

  @override
  State<_DialogTeks> createState() => _DialogTeksState();
}

class _DialogTeksState extends State<_DialogTeks> {
  late final TextEditingController _c =
      TextEditingController(text: widget.awal);
  String? _salah;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _simpan() {
    final teks = _c.text.trim();
    if (teks.length < widget.minimal) {
      setState(() => _salah = widget.pesanMinimal);
      return;
    }
    Navigator.of(context).pop(_HasilDialog.simpan(teks));
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder garis(Color warna, [double lebar = 1.5]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(
        widget.judul,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.hijauGelap,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppColors.hijauGelap,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _c,
              autofocus: true,
              onChanged: (_) {
                if (_salah != null) setState(() => _salah = null);
              },
              onSubmitted: (_) => _simpan(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.hijauGelap,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9AA392),
                ),
                errorText: _salah,
                errorStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB3563F),
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                enabledBorder: garis(_garis),
                focusedBorder: garis(AppColors.hijauSedang, 1.8),
                errorBorder: garis(const Color(0xFFB3563F)),
                focusedErrorBorder: garis(const Color(0xFFB3563F), 1.8),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: [
        if (widget.tombolHapus != null)
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(const _HasilDialog.hapus()),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF8A5A36)),
            child: Text(
              widget.tombolHapus!,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppColors.hijauGelap),
          child: const Text(
            'Batal',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        FilledButton(
          onPressed: _simpan,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.hijauTua,
            foregroundColor: Colors.white,
          ),
          child: Text(
            widget.tombol,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
