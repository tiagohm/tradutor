import 'dart:convert';
import 'dart:io';

import 'package:tradutor/src/build_options.dart';
import 'package:tradutor/src/errors.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/language_options.dart';
import 'package:tradutor/src/message.dart';
import 'package:tradutor/src/regex.dart';
import 'package:tradutor/src/translation_file.dart';

Future<Language> parseTranslationFile(
  TranslationFile translationFile,
  BuildOptions options,
) async {
  final file = File(translationFile.file.path);
  final text = await file.readAsString();
  final data = json.decode(text);
  return _parse(translationFile, data as Map<String, dynamic>);
}

Language _parse(
  TranslationFile file,
  Map<String, dynamic> data,
) {
  final messages = List<Message>();
  final options = Map<String, String>();

  data.forEach((key, value) {
    if (value == null) return;

    // Option.
    var match = _matchesOptionKey(key);
    if (match != null) {
      if (value is List || value is Map)
        throw ParseError("option '$key' has an invalid value");

      final option = match.group(1);
      options[option] = value?.toString();
      return;
    }

    // Plural.
    match = _matchesPluralKey(key);
    if (match != null) {
      final key = match.group(1);
      final type = match.group(2).toLowerCase();

      if (value is List) {
        throw ParseError("'$key': plural message not support array");
      } else if (value is Map) {
        throw ParseError("'$key': plural message not support child");
      } else {
        final message = StringMessage(key, value.toString());
        messages.add(PluralMessage(type, message));
        return;
      }
    }

    // Singular.
    match = _matchesKey(key);
    if (match != null) {
      final key = match.group(1);
      Message message;

      if (value is List) {
        message = ListMessage(
          key,
          [for (final item in value) item.toString()],
        );
      } else if (value is Map) {
        throw ParseError("$key key: singular message not support child yet");
      } else {
        message = StringMessage(key, value.toString());
      }

      messages.add(message);
      return;
    }

    throw ParseError("'$key' is a invalid key");
  });

  return Language(
    messages,
    LanguageOptions.fromMap(options),
    file.languageCode,
    file.countryCode,
  );
}

Match _matchesOptionKey(String key) {
  return optionKeyRegex.firstMatch(key);
}

Match _matchesPluralKey(String key) {
  return pluralKeyRegex.firstMatch(key);
}

Match _matchesKey(String key) {
  return keyRegex.firstMatch(key);
}
