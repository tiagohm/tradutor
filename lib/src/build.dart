import 'package:dart_style/dart_style.dart';
import 'package:tradutor/src/build_options.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/message.dart';
import 'package:tradutor/src/regex.dart';

String buildTranslationDartFile(
  List<Language> languages,
  BuildOptions options,
) {
  final sb = StringBuffer();

  final hideSynchronousFuture = options.isWeb ? " hide SynchronousFuture" : "";
  sb.writeln("import 'package:flutter/foundation.dart'$hideSynchronousFuture;");
  sb.writeln(options.isWeb
      ? "import 'package:flutter_web/widgets.dart';"
      : "import 'package:flutter/widgets.dart';");
  sb.writeln("import 'package:intl/intl.dart' hide TextDirection;");
  sb.writeln();
  sb.writeln("// ignore_for_file: camel_case_types");
  sb.writeln("// ignore_for_file: prefer_single_quotes");
  sb.writeln("// ignore_for_file: non_constant_identifier_names");
  sb.writeln("// ignore_for_file: unnecessary_brace_in_string_interps");
  sb.writeln("// ignore_for_file: unused_import");
  sb.writeln("// ignore_for_file: curly_braces_in_flow_control_structures");
  sb.writeln();
  sb.writeln(
      "// See more about language plural rules: https://www.unicode.org/cldr/charts/33/supplemental/language_plural_rules.html");
  sb.writeln();

  // Fallback vem em primeiro, depois os idiomas por ordem alfabética.
  languages = List.of(languages)
    ..sort((a, b) {
      final aIsFallback = a.locale == options.fallback;
      final bIsFallback = b.locale == options.fallback;
      if (aIsFallback == bIsFallback) return a.locale.compareTo(b.locale);
      if (aIsFallback) return -1;
      return 1;
    });

  // Percorre cada idioma.
  for (final language in languages) {
    final isFallback = language.locale == options.fallback;
    if (isFallback) {
      sb.writeln(_buildI18nClass(language, options.className));
      sb.writeln(_buildLanguageClass(language, true, options.className));
    } else {
      sb.writeln(_buildLanguageClass(language, false, options.className));
    }
  }

  sb.writeln(
    _buildGeneratedLocalizationsDelegate(options.className, languages),
  );

  final text = sb.toString();
  return DartFormatter().format(text);
}

String _buildI18nClass(
  Language language,
  String className,
) {
  final messages = _buildMessagesLanguage(language, true);

  final text = """
class $className implements WidgetsLocalizations {
  const $className();

  static Locale _locale;
  static bool _shouldReload = false;

  static Locale get locale => _locale;

  static set locale(Locale locale) {
    _shouldReload = true;
    _locale = locale;
  }

  static const GeneratedLocalizationsDelegate delegate =
      GeneratedLocalizationsDelegate();

  static $className of(BuildContext context) =>
      Localizations.of<$className>(context, WidgetsLocalizations);

  @override
  TextDirection get textDirection => TextDirection.ltr;

  String get language => "${language.locale}";

  $messages
}
""";

  return text;
}

String _buildLanguageClass(
  Language language,
  bool isFallback,
  String className,
) {
  final messages = isFallback ? "" : _buildMessagesLanguage(language, false);
  final extendsOf = language.options.extendsOf == null
      ? "$className"
      : "_${className}_${language.options.extendsOf}";

  return """
class _${className}_${language.locale} extends $extendsOf {
  const _${className}_${language.locale}();

  @override
  TextDirection get textDirection => TextDirection.${language.options.textDirection};

  @override
  String get language => "${language.locale}";

  $messages
}
""";
}

String _buildMessagesLanguage(
  Language language,
  bool isFallback,
) {
  final sb = StringBuffer();

  final singularMessages = List<Message>();
  final pluralMessages = Map<String, List<PluralMessage>>();
  final messages = List<MapEntry<String, String>>();

  for (final message in language.messages) {
    if (message is PluralMessage) {
      pluralMessages
          .putIfAbsent(message.key, () => List<PluralMessage>())
          .add(message);
    } else {
      singularMessages.add(message);
    }
  }

  for (final message in singularMessages) {
    if (message is StringMessage) {
      messages.add(MapEntry(
        message.key,
        _buildStringMessage(message, language, isFallback),
      ));
    } else if (message is ListMessage) {
      messages.add(MapEntry(
        message.key,
        _buildListMessage(message, language, isFallback),
      ));
    }
  }

  pluralMessages.forEach((key, values) {
    messages.add(MapEntry(
      key,
      _buildPluralMessage(
        key,
        values,
        language,
        isFallback,
      ),
    ));
  });

  messages.sort((a, b) => a.key.compareTo(b.key));

  for (final item in messages) {
    sb.writeln(item.value);
  }

  return sb.toString();
}

String _buildStringMessage(
  StringMessage message,
  Language language,
  bool isFallback,
) {
  final sb = StringBuffer();
  final params = List<String>();
  var value = message.value;

  // Parâmetros.
  while (true) {
    final match = paramRegex.firstMatch(value);

    if (match == null) break;

    final name = match.group(1);
    if (!params.contains(name)) params.add(name);
    value = value.replaceRange(match.start, match.end, "\${$name}");
  }

  if (!isFallback) sb.writeln("@override");
  sb.write("String");

  if (params.isEmpty) {
    sb.write(" get");
  }

  sb.write(" ${message.key}");

  if (params.isNotEmpty) {
    params.sort();

    sb.write("(");
    sb.write(params.join(","));
    sb.write(")");
  }

  sb.write(" => ");

  sb.write('"$value"');

  sb.write(";");

  return sb.toString();
}

String _buildListMessage(
  ListMessage message,
  Language language,
  bool isFallback,
) {
  final sb = StringBuffer();
  final params = List<String>();
  final values = List<String>();

  // Parâmetros.
  for (var value in message.value) {
    while (true) {
      final match = paramRegex.firstMatch(value);

      if (match == null) break;

      final name = match.group(1);
      if (!params.contains(name)) params.add(name);
      value = value.replaceRange(match.start, match.end, "\${$name}");
    }

    values.add('"$value"');
  }

  if (!isFallback) sb.writeln("@override");
  sb.write("List<String>");

  if (params.isEmpty) {
    sb.write(" get");
  }

  sb.write(" ${message.key}");

  if (params.isNotEmpty) {
    params.sort();

    sb.write("(");
    sb.write(params.join(","));
    sb.write(")");
  }

  sb.write(" => ");

  sb.write("[" + values.join(",") + "]");

  sb.write(";");

  return sb.toString();
}

String _buildPluralMessage(
  String key,
  List<PluralMessage> messages,
  Language language,
  bool isFallback,
) {
  final sb = StringBuffer();
  final params = List<String>();
  final values = Map<String, String>();

  // Parâmetros.
  for (final message in messages) {
    var value = message.value;

    while (true) {
      final match = paramRegex.firstMatch(value);

      if (match == null) break;

      final name = match.group(1);
      if (!params.contains(name)) params.add(name);
      value = value.replaceRange(match.start, match.end, "\${$name}");
    }

    values[message.type] = '"$value"';
  }

  if (!isFallback) sb.writeln("@override");
  sb.write("String");

  if (params.isEmpty) {
    sb.write(" get");
  }

  sb.write(" $key");

  if (params.isNotEmpty) {
    params.remove("quantity");
    params.sort();
    params.insert(0, "quantity");

    sb.write("(");
    sb.write(params.join(","));
    sb.write(")");
  }

  sb.write(" => ");

  if (values.length == 1) {
    sb.write(values.values.first);
  } else {
    final zero = values["zero"];
    final one = values["one"];
    final two = values["two"];
    final few = values["few"];
    final many = values["many"];
    final other = values["other"];

    sb.write('Intl.plural(quantity, locale: language,');
    if (zero != null) sb.write(" zero: $zero,");
    if (one != null) sb.write(" one: $one,");
    if (two != null) sb.write(" two: $two,");
    if (few != null) sb.write(" few: $few,");
    if (many != null) sb.write(" many: $many,");
    if (other != null) sb.write(" other: $other,");
    sb.write(")");
  }

  sb.write(";");

  return sb.toString();
}

String _buildGeneratedLocalizationsDelegate(
  String className,
  List<Language> languages,
) {
  final supportedLocales = StringBuffer();
  final localizationsBylang = StringBuffer();
  final localizationsByLanguageCode = StringBuffer();

  for (final language in languages) {
    supportedLocales.writeln(
        'Locale("${language.languageCode}", "${language.countryCode}"),');
    localizationsBylang.writeln('if ("${language.locale}" == lang)');
    localizationsBylang.writeln(
        'return SynchronousFuture<WidgetsLocalizations>(const _${className}_${language.locale}());');

    if (language.options.extendsOf == null ||
        language.options.extendsOf.isEmpty) {
      final languageCode = language.languageCode;
      localizationsByLanguageCode
          .writeln('if ("$languageCode" == languageCode)');
      localizationsByLanguageCode.writeln(
          'return SynchronousFuture<WidgetsLocalizations>(const _${className}_${language.locale}());');
    }
  }

  final text = """
class GeneratedLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      $supportedLocales
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
  Future<WidgetsLocalizations> load(Locale locale) {
    $className._locale ??= locale;
    $className._shouldReload = false;
    locale = $className._locale;
    final String lang = locale != null ? locale.toString() : "";
    final String languageCode = locale != null ? locale.languageCode : "";

    $localizationsBylang

    $localizationsByLanguageCode

    return SynchronousFuture<WidgetsLocalizations>(const $className());
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
  bool shouldReload(GeneratedLocalizationsDelegate old) => $className._shouldReload;
}
""";

  return text;
}
