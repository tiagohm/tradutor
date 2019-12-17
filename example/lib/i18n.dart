import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unused_import
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: implicit_dynamic_parameter

// See more about language plural rules: https://www.unicode.org/cldr/charts/33/supplemental/language_plural_rules.html

class I18n implements WidgetsLocalizations {
  const I18n();

  static Locale _locale;
  static bool _shouldReload = false;

  static Locale get locale => _locale;

  static set locale(Locale locale) {
    _shouldReload = true;
    _locale = locale;
  }

  static const GeneratedLocalizationsDelegate delegate =
      GeneratedLocalizationsDelegate();

  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, WidgetsLocalizations);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get language => 'en_US';

  List<String> get brazilFlagColors => ['Green', 'Yellow', 'Blue', 'White'];
  String counter(num quantity) => Intl.plural(
        quantity,
        locale: language,
        one: 'Button clicked 1 time',
        other: 'Button clicked ${quantity} times',
      );
  String get homePageTitle => 'Home Page';
  String messageWithParameters(name) => 'Hi ${name}, Welcome you!';
  String get simpleMessage => 'This is a simple Message';
  List<String> simpleWhiteCakeIngredients(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        '${whiteSugar} cup white sugar',
        '${butter} cup butter',
        '${eggs} eggs',
        '${vanilla} teaspoons vanilla extract',
        '${flour} cups all-purpose flour',
        '${bakingPowder} teaspoons baking powder',
        '${milk} cup milk'
      ];
}

class _I18n_en_US extends I18n {
  const _I18n_en_US();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get language => 'en_US';
}

class _I18n_ja_JA extends I18n {
  const _I18n_ja_JA();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get language => 'ja_JA';

  @override
  List<String> get brazilFlagColors => ['緑', '黄色', '青い', '白い'];
  @override
  String counter(num quantity) => 'ボタンが${quantity}回クリックされた';
  @override
  String get homePageTitle => 'ホームページ';
  @override
  String messageWithParameters(name) => '${name}様、ようこそ！';
  @override
  String get simpleMessage => 'これは簡単なメッセージです';
  @override
  List<String> simpleWhiteCakeIngredients(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        '白砂糖${whiteSugar}カップ',
        'バター${butter}カップ',
        '卵${eggs}個',
        'バニラエッセンス小さじ${vanilla}',
        '薄力粉${flour}カップ',
        '小さじ${bakingPowder}杯のベーキングパウダー',
        '牛乳${milk}カップ'
      ];
}

class _I18n_pt_BR extends _I18n_pt_PT {
  const _I18n_pt_BR();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get language => 'pt_BR';

  @override
  String counter(num quantity) => Intl.plural(
        quantity,
        locale: language,
        one: 'Botão foi pressionado ${quantity} vez',
        other: 'Botão foi pressionado ${quantity} vezes',
      );
}

class _I18n_pt_PT extends I18n {
  const _I18n_pt_PT();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get language => 'pt_PT';

  @override
  List<String> get brazilFlagColors => ['Verde', 'Amarelo', 'Azul', 'Branco'];
  @override
  String counter(num quantity) => Intl.plural(
        quantity,
        locale: language,
        one: 'Botão foi clicado 1 vez',
        other: 'Botão foi clicado ${quantity} vezes',
      );
  @override
  String get homePageTitle => 'Página Inicial';
  @override
  String messageWithParameters(name) => 'Olá ${name}, Bem-vindo!';
  @override
  String get simpleMessage => 'Esta é uma simples mensagem';
  @override
  List<String> simpleWhiteCakeIngredients(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        '${whiteSugar} copo de açúcar cristal',
        '${butter} copo de manteiga',
        '${eggs} ovos',
        '${vanilla} colheres de chá de extrato de baunilha',
        '${flour} copo de farinha de trigo',
        '${bakingPowder} colher de fermento em pó',
        '${milk} copo de leite'
      ];
}

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', 'US'),
      Locale('ja', 'JA'),
      Locale('pt', 'BR'),
      Locale('pt', 'PT'),
    ];
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      if (isSupported(locale)) {
        return locale;
      }
      final fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    I18n._locale ??= locale;
    I18n._shouldReload = false;
    locale = I18n._locale;
    final lang = locale != null ? locale.toString() : '';
    final languageCode = locale != null ? locale.languageCode : '';

    if ('en_US' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }
    if ('ja_JA' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_ja_JA());
    }
    if ('pt_BR' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_BR());
    }
    if ('pt_PT' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());
    }

    if ('en' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }
    if ('ja' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_ja_JA());
    }
    if ('pt' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());
    }

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
