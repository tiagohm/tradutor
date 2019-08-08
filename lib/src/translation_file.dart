import 'dart:io';

import 'package:tradutor/src/locale.dart';

class TranslationFile extends Locale {
  final FileSystemEntity file;
  final String languageCode;
  final String countryCode;

  TranslationFile(
    this.file,
    this.languageCode,
    this.countryCode,
  );

  @override
  String toString() {
    return "TranslationFile { locale: $locale, file: ${file.path} }";
  }
}
