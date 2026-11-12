import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Kolom isian dengan label di atasnya (gaya desain Somniva).
class KolomTeks extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool sembunyikan;
  final TextInputType? jenisKeyboard;
  final String? Function(String?)? validator;
  final Widget? ikonKanan;
  final TextInputAction? aksi;
  final void Function(String)? onSubmitted;

  const KolomTeks({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.sembunyikan = false,
    this.jenisKeyboard,
    this.validator,
    this.ikonKanan,
    this.aksi,
    this.onSubmitted,
  });

  OutlineInputBorder _garis(Color warna, [double lebar = 1.2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: warna, width: lebar),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.hijauGelap,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: sembunyikan,
          keyboardType: jenisKeyboard,
          textInputAction: aksi,
          onFieldSubmitted: onSubmitted,
          validator: validator,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.hijauGelap,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9AA392),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: ikonKanan,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            enabledBorder: _garis(AppColors.hijauPastel),
            focusedBorder: _garis(AppColors.hijauSedang, 1.6),
            errorBorder: _garis(const Color(0xFFB3563F)),
            focusedErrorBorder: _garis(const Color(0xFFB3563F), 1.6),
            errorStyle: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB3563F),
            ),
          ),
        ),
      ],
    );
  }
}
