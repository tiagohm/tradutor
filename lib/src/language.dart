import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String code;
  final String country;

  static final _languageRegex = RegExp(r'^[a-z]{2}_[a-zA-Z]{2}$');

  Language(String code, String country)
      : code = code.toLowerCase(),
        country = country.toUpperCase();

  factory Language.parse(String text) {
    if (!matches(text)) {
      throw ArgumentError('Invalid format for language $text');
    }

    final code = text.substring(0, 2);
    final country = text.substring(3);
    return Language(code, country);
  }

  static bool matches(String text) {
    return _languageRegex.hasMatch(text);
  }

  @override
  String toString() {
    return '${code}_$country';
  }

  @override
  List<Object> get props => [code, country];
}
