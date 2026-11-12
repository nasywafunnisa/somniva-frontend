/// Aturan pengecekan isian formulir. Dipakai Login dan Registrasi.
class Validator {
  Validator._();

  static String? nama(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Nama wajib diisi';
    if (t.length < 2) return 'Nama terlalu pendek';
    return null;
  }

  static String? email(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) {
      return 'Format email belum benar';
    }
    return null;
  }

  static String? sandi(String? v) {
    final t = v ?? '';
    if (t.isEmpty) return 'Kata sandi wajib diisi';
    if (t.length < 6) return 'Minimal 6 karakter';
    return null;
  }
}
