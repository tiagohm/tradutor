import 'package:tradutor/src/errors.dart';
import 'package:tradutor/src/regex.dart';

class LanguageOptions {
  final String textDirection;
  final String extendsOf;

  LanguageOptions({
    this.textDirection = 'ltr',
    this.extendsOf,
  }) {
    if (extendsOf != null &&
        extendsOf.isNotEmpty &&
        !localeRegex.hasMatch(extendsOf)) {
      throw ParseError('extends property has invalid value');
    }
  }

  factory LanguageOptions.fromMap(Map<String, String> options) {
    return LanguageOptions(
      textDirection: options['textDirection'] ?? 'ltr',
      extendsOf: options['extends'],
    );
  }
}
