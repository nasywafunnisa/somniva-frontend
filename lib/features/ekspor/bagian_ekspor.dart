import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../core/app_colors.dart';
import '../../core/buat_pdf.dart';
import '../../core/laporan_tidur.dart';

/// Pilihan rentang: 7 hari | 30 hari | Bulan ini.
class ChipRentangLaporan extends StatelessWidget {
  final RentangLaporan nilai;
  final ValueChanged<RentangLaporan> onPilih;

  const ChipRentangLaporan({super.key, required this.nilai, required this.onPilih});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [for (final r in RentangLaporan.values) _satu(r)],
    );
  }

  Widget _satu(RentangLaporan r) {
    final aktif = r == nilai;
    return Material(
      color: aktif ? AppColors.hijauTua : AppColors.krim,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onPilih(r),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Text(
            r.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.hijauGelap,
            ),
          ),
        ),
      ),
    );
  }
}

/// Satu baris kotak centang "Isi laporan".
class BarisCentang extends StatelessWidget {
  final String teks;
  final bool nilai;
  final ValueChanged<bool> onUbah;
  final double ukuran;

  const BarisCentang({
    super.key,
    required this.teks,
    required this.nilai,
    required this.onUbah,
    this.ukuran = 40,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onUbah(!nilai),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: ukuran,
              height: ukuran,
              decoration: BoxDecoration(
                color: nilai ? AppColors.hijauTua : Colors.white,
                borderRadius: BorderRadius.circular(ukuran * 0.25),
                border: Border.all(
                  color: nilai ? AppColors.hijauTua : AppColors.titikMati,
                  width: 1.8,
                ),
              ),
              child: nilai
                  ? Icon(Icons.check_rounded,
                      size: ukuran * 0.7, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                teks,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.hijauGelap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empat kotak centang isi laporan.
class DaftarIsiLaporan extends StatelessWidget {
  final IsiLaporan isi;
  final ValueChanged<IsiLaporan> onUbah;
  final double ukuran;

  const DaftarIsiLaporan({
    super.key,
    required this.isi,
    required this.onUbah,
    this.ukuran = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BarisCentang(
          teks: 'Sleep Score & faktor',
          nilai: isi.faktor,
          ukuran: ukuran,
          onUbah: (v) => onUbah(isi.ubah(faktor: v)),
        ),
        BarisCentang(
          teks: 'Sleep Debt',
          nilai: isi.debt,
          ukuran: ukuran,
          onUbah: (v) => onUbah(isi.ubah(debt: v)),
        ),
        BarisCentang(
          teks: 'Pola & korelasi',
          nilai: isi.pola,
          ukuran: ukuran,
          onUbah: (v) => onUbah(isi.ubah(pola: v)),
        ),
        BarisCentang(
          teks: 'Riwayat per malam',
          nilai: isi.riwayat,
          ukuran: ukuran,
          onUbah: (v) => onUbah(isi.ubah(riwayat: v)),
        ),
      ],
    );
  }
}

/// Tiga angka ringkasan: rata-rata skor, rata-rata tidur, Sleep Debt.
class BarisAngkaLaporan extends StatelessWidget {
  final LaporanTidur laporan;
  final bool tengah;

  const BarisAngkaLaporan({super.key, required this.laporan, this.tengah = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _angka('${laporan.rataSkor}', 'Rata-rata skor'),
        _angka(laporan.rataDurasiTeks, 'Rata-rata tidur'),
        _angka(laporan.debtTeks, 'Sleep Debt'),
      ],
    );
  }

  Widget _angka(String nilai, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            tengah ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 27,
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

/// Aksi tombol Unduh / Bagikan / Pratinjau.
class AksiEkspor {
  AksiEkspor._();

  static void _pesan(BuildContext context, String teks) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(teks)),
    );
  }

  static bool _cek(BuildContext context, IsiLaporan isi) {
    if (isi.kosong) {
      _pesan(context, 'Pilih minimal satu bagian di "Isi laporan".');
      return false;
    }
    return true;
  }

  /// Unduh: di web file langsung terunduh, di HP muncul menu simpan/kirim.
  static Future<void> unduh(
      BuildContext context, RentangLaporan rentang, IsiLaporan isi) async {
    if (!_cek(context, isi)) return;
    try {
      final l = LaporanTidur.buat(rentang);
      final bytes = await buatPdfLaporan(l, isi);
      await Printing.sharePdf(bytes: bytes, filename: l.namaFile);
      if (context.mounted) _pesan(context, 'Laporan PDF siap: ${l.namaFile}');
    } catch (e) {
      if (context.mounted) _pesan(context, 'Gagal membuat PDF: $e');
    }
  }

  /// Bagikan: di HP membuka menu bagikan bawaan, di web sama dengan unduh.
  static Future<void> bagikan(
      BuildContext context, RentangLaporan rentang, IsiLaporan isi) async {
    if (!_cek(context, isi)) return;
    try {
      final l = LaporanTidur.buat(rentang);
      final bytes = await buatPdfLaporan(l, isi);
      await Printing.sharePdf(
        bytes: bytes,
        filename: l.namaFile,
        subject: 'Laporan Tidur Somniva ${l.periode(pemisah: '-')}',
        body: 'Ringkasan tidur dari Somniva (bersifat edukatif).',
      );
    } catch (e) {
      if (context.mounted) _pesan(context, 'Gagal membagikan PDF: $e');
    }
  }

  /// Pratinjau: membuka tampilan cetak/simpan PDF bawaan browser atau HP.
  static Future<void> pratinjau(
      BuildContext context, RentangLaporan rentang, IsiLaporan isi) async {
    if (!_cek(context, isi)) return;
    try {
      final l = LaporanTidur.buat(rentang);
      await Printing.layoutPdf(
        name: l.namaFile,
        onLayout: (_) => buatPdfLaporan(l, isi),
      );
    } catch (e) {
      if (context.mounted) _pesan(context, 'Gagal membuka pratinjau: $e');
    }
  }
}
