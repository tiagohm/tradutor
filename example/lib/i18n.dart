import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

class _I18n_pt_PT extends I18n {
  const _I18n_pt_PT();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get locale => "pt_PT";

  @override
  List<String> get brazilFlagColors => ["Verde", "Amarelo", "Azul", "Branco"];
  @override
  String counter(quantity) => Intl.plural(
        quantity,
        locale: locale,
        one: "Botão foi clicado 1 vez",
        other: "Botão foi clicado ${quantity} vezes",
      );
  @override
  String get homePageTitle => "Página Inicial";
  @override
  String messageWithParameters(name) => "Olá ${name}, Bem-vindo!";
  @override
  String get simpleMessage => "Esta é uma simples mensagem";
  @override
  List<String> simpleWhiteCakeReceipt(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        "${whiteSugar} copo de açúcar cristal",
        "${butter} copo de manteiga",
        "${eggs} ovos",
        "${vanilla} colheres de chá de extrato de baunilha",
        "${flour} copo de farinha de trigo",
        "${bakingPowder} colher de fermento em pó",
        "${milk} copo de leite"
      ];
}

class I18n implements WidgetsLocalizations {
  const I18n();

  static Locale _locale;
  static bool _shouldReload = false;

  static changeLocale(Locale newLocale) {
    _shouldReload = true;
    _locale = newLocale;
  }

  static const GeneratedLocalizationsDelegate delegate =
      const GeneratedLocalizationsDelegate();

  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, WidgetsLocalizations);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get locale => "en_US";

  List<String> get brazilFlagColors => ["Green", "Yellow", "Blue", "White"];
  String counter(quantity) => Intl.plural(
        quantity,
        locale: locale,
        one: "Button clicked 1 time",
        other: "Button clicked ${quantity} times",
      );
  String get homePageTitle => "Home Page";
  String messageWithParameters(name) => "Hi ${name}, Welcome you!";
  String get simpleMessage => "This is a simple Message";
  List<String> simpleWhiteCakeReceipt(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        "${whiteSugar} cup white sugar",
        "${butter} cup butter",
        "${eggs} eggs",
        "${vanilla} teaspoons vanilla extract",
        "${flour} cups all-purpose flour",
        "${bakingPowder} teaspoons baking powder",
        "${milk} cup milk"
      ];
}

class _I18n_en_US extends I18n {
  const _I18n_en_US();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get locale => "en_US";
}

class _I18n_pt_BR extends _I18n_pt_PT {
  const _I18n_pt_BR();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get locale => "pt_BR";

  @override
  String counter(quantity) => Intl.plural(
        quantity,
        locale: locale,
        one: "Botão foi pressionado ${quantity} vez",
        other: "Botão foi pressionado ${quantity} vezes",
      );
}

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      const Locale("pt", "PT"),
      const Locale("en", "US"),
      const Locale("pt", "BR"),
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

    if ("pt_PT" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());
    if ("en_US" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    if ("pt_BR" == lang)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_BR());

    if ("pt" == languageCode)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());
    if ("en" == languageCode)
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());

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
