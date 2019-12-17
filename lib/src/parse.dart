import 'dart:convert';
import 'dart:io';

import 'package:tradutor/src/build_options.dart';
import 'package:tradutor/src/errors.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/language_options.dart';
import 'package:tradutor/src/message.dart';
import 'package:tradutor/src/regex.dart';
import 'package:tradutor/src/translation_file.dart';
import 'package:tradutor/src/yaml.dart';

import 'message.dart';

Future<Language> parseTranslationFile(
  TranslationFile translationFile,
  BuildOptions options,
) async {
  final file = File(translationFile.file.path);
  final text = await file.readAsString();
  final dynamic data =
      translationFile.isYaml ? yaml.decode(text) : json.decode(text);
  return _parse(translationFile, data as Map<String, dynamic>);
}

Language _parse(
  TranslationFile file,
  Map<String, dynamic> data,
) {
  final messages = _parseMap(data);
  final options = <String, String>{};

  data.forEach((key, dynamic value) {
    if (key.isEmpty) {
      throw ParseError("key '$key' can't be empty");
    }

    // Option.
    final matchOption = _matchesOptionKey(key);
    if (matchOption != null) {
      if (value == null || value is List || value is Map) {
        throw ParseError("property '$key' has an invalid value");
      }

      final option = matchOption.group(1);
      options[option] = value?.toString();
    }
  });

  return Language(
    messages,
    LanguageOptions.fromMap(options),
    file.languageCode,
    file.countryCode,
  );
}

List<Message> _parseMap(
  Map<String, dynamic> data, [
  String parentKey,
]) {
  final messages = <Message>[];

  data.forEach((key, dynamic value) {
    if (key.isEmpty) {
      throw ParseError("key '$key' can't be empty");
    }

    if (value == null) {
      throw ParseError("key '$key' has an invalid value: null");
    }

    // Option.
    if (_matchesOptionKey(key) != null) {
      return;
    }

    // Date.
    final matchDate = _matchesDateKey(key);

    if (matchDate != null) {
      if (value is String) {
        final key = matchDate.group(1);
        messages.add(DateMessage(key, value));
        return;
      } else {
        throw ParseError("key '$key': date message must be a string");
      }
    }

    // Plural.
    final matchPlural = _matchesPluralKey(key);

    if (matchPlural != null) {
      final key = matchPlural.group(1);
      final type = matchPlural.group(2).toLowerCase();

      if (value is List) {
        throw ParseError("key '$key': plural message doesn't support list");
      } else if (value is Map) {
        throw ParseError("key '$key': plural message doesn't support child");
      } else {
        final message = StringMessage(key, value.toString());
        messages.add(PluralMessage(type, message));
        return;
      }
    }

    // Singular.
    final matchSingular = _matchesKey(key);

    if (matchSingular != null) {
      final key = matchSingular.group(1);
      Message message;

      if (value is List) {
        message = ListMessage(
          _concatWithParentKey(parentKey, key),
          [for (final item in value) item.toString()],
        );
      } else if (value is Map<String, dynamic>) {
        messages.addAll(_parseMap(value, _concatWithParentKey(parentKey, key)));
        return;
      } else {
        message = StringMessage(
          _concatWithParentKey(parentKey, key),
          value.toString(),
        );
      }

      messages.add(message);
      return;
    }

    throw ParseError("'$key' is a invalid key");
  });

  return messages;
}

String _concatWithParentKey(
  String parentKey,
  String key,
) {
  if (parentKey == null || parentKey.isEmpty) {
    return key;
  } else if (key.length > 1) {
    return parentKey + key[0].toUpperCase() + key.substring(1);
  } else {
    return parentKey + key.toUpperCase();
  }
}

Match _matchesOptionKey(String key) {
  return optionKeyRegex.firstMatch(key);
}

Match _matchesDateKey(String key) {
  return dateKeyRegex.firstMatch(key);
}

Match _matchesPluralKey(String key) {
  return pluralKeyRegex.firstMatch(key);
}

Match _matchesKey(String key) {
  return keyRegex.firstMatch(key);
}
