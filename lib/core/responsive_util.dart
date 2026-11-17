import 'package:flutter/widgets.dart';

/// Sama dengan batas di BerandaPage: lebar jendela mulai angka ini = tampilan web.
const double batasLebarWeb = 900;

bool sedangLebar(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= batasLebarWeb;
}
