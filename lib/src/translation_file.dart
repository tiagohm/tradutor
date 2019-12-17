import 'dart:io';

import 'package:tradutor/src/locale.dart';

class TranslationFile extends Locale {
  final FileSystemEntity file;
  @override
  final String languageCode;
  @override
  final String countryCode;

  TranslationFile(
    this.file,
    this.languageCode,
    this.countryCode,
  );

  bool get isJson => file.path.endsWith('.json');

  bool get isYaml => file.path.endsWith('.yaml');

  @override
  String toString() {
    return 'TranslationFile { locale: $locale, file: ${file.path} }';
  }
}
