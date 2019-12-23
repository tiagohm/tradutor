import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unused_import
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
        one: 'Button tapped ${quantity} time',
        other: 'Button tapped ${quantity} times',
      );
  static final _fullDateFormatter =
      DateFormat('MM dd, yyyy h:mm:ss a', 'en_US');
  String fullDate(DateTime date) => _fullDateFormatter.format(date);
  String get homePage => 'Home Page';
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

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', 'US'),
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

    if ('en' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
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
