import 'package:tradutor/src/language_options.dart';
import 'package:tradutor/src/locale.dart';
import 'package:tradutor/src/message.dart';

class Language extends Locale {
  final List<Message> messages;
  final LanguageOptions options;
  final String languageCode;
  final String countryCode;

  Language(
    this.messages,
    this.options,
    this.languageCode,
    this.countryCode,
  );

  @override
  String toString() {
    return "Language { locale: $locale, message: $messages, options: $options }";
  }
}
