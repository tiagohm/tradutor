import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

class I18n implements WidgetsLocalizations {
  const I18n();

  static Locale _locale;
  static bool _shouldReload = false;

  static set locale(Locale _newLocale) {
    _shouldReload = true;
    _locale = _newLocale;
  }

  static const GeneratedLocalizationsDelegate delegate =
      const GeneratedLocalizationsDelegate();

  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, WidgetsLocalizations);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  List<String> get arrayMessage => ["White", "Blue", "Yellow"];
  List<String> get arrayMessageWithParameters => [""];
  String get homePageTitle => "Home Page";
  String get increment => "Increment";
  String message(quantity) => Intl.plural(
        quantity,
        locale: "en_US",
        zero: null,
        one: "Button clicked 1 time",
        two: null,
        few: null,
        many: null,
        other: "Button clicked $quantity times",
      );
  String messageWithParams(name) => "Hi $name, welcome you!";
  String pluralMessage(quantity, name) => Intl.plural(
        quantity,
        locale: "en_US",
        zero: null,
        one: "Hi $name, I have one year working experience.",
        two: null,
        few: null,
        many: null,
        other: "Hi $name, I have $quantity years of working experience.",
      );
  String get simpleMessage => "This is a simple message";
}

class _I18n_en_US extends I18n {
  const _I18n_en_US();

  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class _I18n_pt_BR extends _I18n_pt_PT {
  const _I18n_pt_BR();

  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class _I18n_pt_PT extends I18n {
  const _I18n_pt_PT();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  List<String> get arrayMessage => ["Branco", "Azul", "Amarelo"];
  List<String> get arrayMessageWithParameters => [""];
  @override
  String get homePageTitle => "Página Inicial";
  @override
  String get increment => "Incrementar";
  String message(quantity) => Intl.plural(
        quantity,
        locale: "pt_PT",
        zero: null,
        one: "Botão clicado 1 vez",
        two: null,
        few: null,
        many: null,
        other: "Botão clicado $quantity vezes",
      );
  @override
  String messageWithParams(name) => "Olá $name, seja bem-vindo!";
  String pluralMessage(quantity, name) => Intl.plural(
        quantity,
        locale: "pt_PT",
        zero: null,
        one: "Olá $name, eu tenho 1 ano de experiência de trabalho.",
        two: null,
        few: null,
        many: null,
        other: "Olá $name, eu tenho $quantity anos de experiência de trabalho.",
      );
  @override
  String get simpleMessage => "Esta é uma simples mensagem";
}

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      const Locale("en", "US"),
      const Locale("pt", "BR"),
      const Locale("pt", "PT"),
    ];
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      if (this.isSupported(locale)) {
        return locale;
      }
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale _locale) {
    I18n._locale ??= _locale;
    I18n._shouldReload = false;
    final Locale locale = I18n._locale;
    final String lang = locale != null ? locale.toString() : "";
    final String languageCode = locale != null ? locale.languageCode : "";

    if ("en_US" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    if ("pt_BR" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_BR());
    if ("pt_PT" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());

    if ("en" == languageCode)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    if ("pt" == languageCode)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());

    return SynchronousFuture<WidgetsLocalizations>(const I18n());
  }

  @override
  bool isSupported(Locale locale) {
    for (var i = 0; i < supportedLocales.length && locale != null; i++) {
      final l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => I18n._shouldReload;
}
