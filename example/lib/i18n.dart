import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unnecessary_brace_in_string_interps
// ignore_for_file: unused_import
// ignore_for_file: implicit_dynamic_parameter

// See more about language plural rules: https://www.unicode.org/cldr/charts/33/supplemental/language_plural_rules.html

const I18n enUS = _I18n_en_US();
const I18n ptBR = _I18n_pt_BR();
const I18n ptPT = _I18n_pt_PT();

class _I18n_en_US extends I18n {
  const _I18n_en_US();
}

class I18n implements WidgetsLocalizations {
  const I18n();

  static Locale _locale;

  static bool _shouldReload = false;

  static const GeneratedLocalizationsDelegate delegate =
      GeneratedLocalizationsDelegate();

  static final _dateMessageFormatter =
      DateFormat('MM dd, yyyy h:mm:ss a', 'en_US');

  static Locale getLocale() => _locale;
  static void setLocale(Locale locale) {
    _shouldReload = true;
    _locale = locale;
  }

  String get language$ => 'en_US';
  TextDirection get textDirection => TextDirection.ltr;
  static I18n of(BuildContext context) =>
      Localizations.of<I18n>(context, WidgetsLocalizations);
  String dateMessage(DateTime date) => _dateMessageFormatter.format(date);
  List<String> get listMessage => ['Green', 'Yellow', 'Blue', 'White'];
  List<String> listMessageWithParameters(
          dynamic whiteSugar,
          dynamic butter,
          dynamic eggs,
          dynamic vanilla,
          dynamic flour,
          dynamic bakingPowder,
          dynamic milk) =>
      [
        '${whiteSugar} cup white sugar',
        '${butter} cup butter',
        '${eggs} eggs',
        '${vanilla} teaspoons vanilla extract',
        '${flour} cups all-purpose flour',
        '${bakingPowder} teaspoons baking powder',
        '${milk} cup milk'
      ];
  String get messageKeyCamelCase => 'This is a message';
  String get messageWithOneCurlyBracket =>
      'This message contains one {curly_bracket}';
  String get messageWithTwoCurlyBrackets =>
      'This message contains two {{curly_brackets}}';
  String get notTranslatable => 'This message is not translatable';
  String pluralMesssage(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Button tapped ${quantity} time',
      other: 'Button tapped ${quantity} times');
  String pluralMesssageGrouped(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Button tapped ${quantity} time',
      other: 'Button tapped ${quantity} times');
  String pluralMesssageWithParameters(
          int quantity, dynamic item, dynamic action) =>
      Intl.plural(quantity,
          locale: language$,
          one: '${item} ${action} ${quantity} time',
          other: '${item} ${action} ${quantity} times');
  String get simpleMessage => 'Home Page';
  String simpleMessageWithParameters(dynamic name) => 'Hello ${name}';
}

class _I18n_pt_BR extends I18n {
  const _I18n_pt_BR();

  static final _dateMessageFormatter =
      DateFormat('dd/MM/yyyy HH:mm:ss', 'en_US');

  String get language$ => 'pt_BR';
  TextDirection get textDirection => TextDirection.ltr;
  String dateMessage(DateTime date) => _dateMessageFormatter.format(date);
  List<String> get listMessage => ['Verde', 'Amarelo', 'Azul', 'Branco'];
  List<String> listMessageWithParameters(
          dynamic whiteSugar,
          dynamic butter,
          dynamic eggs,
          dynamic vanilla,
          dynamic flour,
          dynamic bakingPowder,
          dynamic milk) =>
      [
        '${whiteSugar} copos de açúcar cristal',
        '${butter} copo de manteiga',
        '${eggs} ovos',
        '${vanilla} colher (chá) de extrato de baunilha',
        '${flour} copos de farinha de trigo',
        '${bakingPowder} colher (chá) de fermento em pó',
        '${milk} copo de leite'
      ];
  String get messageKeyCamelCase => 'Isto é uma mensagem';
  String get messageWithOneCurlyBracket => 'Esta mensagem contém uma {chave}';
  String get messageWithTwoCurlyBrackets =>
      'Esta mensagem contém duas {{chaves}}';
  String get notTranslatable => 'This message is not translatable';
  String pluralMesssage(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Botão foi clicado ${quantity} vez',
      other: 'Botão foi clicado ${quantity} vezes');
  String pluralMesssageGrouped(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Button tapped ${quantity} time',
      other: 'Button tapped ${quantity} times');
  String pluralMesssageWithParameters(
          int quantity, dynamic item, dynamic action) =>
      Intl.plural(quantity,
          locale: language$,
          one: '${item} foi ${action} ${quantity} vez',
          other: '${item} foi ${action} ${quantity} vezes');
  String get simpleMessage => 'Página Inicial';
  String simpleMessageWithParameters(dynamic name) => 'Olá ${name}';
}

class _I18n_pt_PT extends I18n {
  const _I18n_pt_PT();

  static final _dateMessageFormatter =
      DateFormat('dd/MM/yyyy HH:mm:ss', 'en_US');

  String get language$ => 'pt_PT';
  TextDirection get textDirection => TextDirection.ltr;
  String dateMessage(DateTime date) => _dateMessageFormatter.format(date);
  List<String> get listMessage => ['Verde', 'Amarelo', 'Azul', 'Branco'];
  List<String> listMessageWithParameters(
          dynamic whiteSugar,
          dynamic butter,
          dynamic eggs,
          dynamic vanilla,
          dynamic flour,
          dynamic bakingPowder,
          dynamic milk) =>
      [
        '${whiteSugar} copos de açúcar cristal',
        '${butter} copo de manteiga',
        '${eggs} ovos',
        '${vanilla} colher (chá) de extrato de baunilha',
        '${flour} copos de farinha de trigo',
        '${bakingPowder} colher (chá) de fermento em pó',
        '${milk} copo de leite'
      ];
  String get messageKeyCamelCase => 'Isto é uma mensagem';
  String get messageWithOneCurlyBracket => 'Esta mensagem contém uma {chave}';
  String get messageWithTwoCurlyBrackets =>
      'Esta mensagem contém duas {{chaves}}';
  String get notTranslatable => 'This message is not translatable';
  String pluralMesssage(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Botão foi pressionado ${quantity} vez',
      other: 'Botão foi pressionado ${quantity} vezes');
  String pluralMesssageGrouped(int quantity) => Intl.plural(quantity,
      locale: language$,
      one: 'Button tapped ${quantity} time',
      other: 'Button tapped ${quantity} times');
  String pluralMesssageWithParameters(
          int quantity, dynamic item, dynamic action) =>
      Intl.plural(quantity,
          locale: language$,
          one: '${item} foi ${action} ${quantity} vez',
          other: '${item} foi ${action} ${quantity} vezes');
  String get simpleMessage => 'Página Inicial';
  String simpleMessageWithParameters(dynamic name) => 'Olá ${name}';
}

class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales =>
      const [Locale('en', 'US'), Locale('pt', 'BR'), Locale('pt', 'PT')];
  LocaleResolutionCallback resolution({Locale fallback}) {
    return (locale, supported) {
      return isSupported(locale) ? locale : (fallback ?? supported.first);
    };
  }

  Future<WidgetsLocalizations> load(Locale locale) {
    I18n._locale ??= locale;
    I18n._shouldReload = false;
    locale = I18n._locale;
    final lang = locale?.toString() ?? '';
    final languageCode = locale?.languageCode ?? '';
    if ('en_US' == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
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
    if ('pt' == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_pt_PT());
    }
    return SynchronousFuture<WidgetsLocalizations>(const I18n());
  }

  bool isSupported(Locale locale) {
    for (var i = 0; i < supportedLocales.length && locale != null; i++) {
      final l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  bool shouldReload(GeneratedLocalizationsDelegate old) => I18n._shouldReload;
}
