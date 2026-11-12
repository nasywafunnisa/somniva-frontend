import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'jurnal_tidur_isi.dart';

/// Halaman "Catat tidur" untuk tampilan WEB (dibuka dari Dashboard).
/// Desain web belum ada untuk halaman ini, jadi isinya sama dengan versi HP.
class JurnalWebPage extends StatelessWidget {
  const JurnalWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krimTerang,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
              child: Row(
                children: [
                  Material(
                    color: AppColors.krim,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).pop(),
                      child: const SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: AppColors.hijauGelap,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Kembali ke Dashboard',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: JurnalTidurIsi(
                    setelahSimpan: () => Navigator.of(context).pop(true),
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
