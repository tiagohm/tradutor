import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:tradutor/src/build_options.dart';
import 'package:tradutor/src/pen.dart';
import 'package:tradutor/src/regex.dart';
import 'package:tradutor/src/translation_file.dart';

Future<List<TranslationFile>> discoveryTranslationFiles(
  BuildOptions options,
) async {
  final current = Directory.current;

  final inputPath =
      Directory(path.normalize('${current.path}/${options.source}'));

  if (!inputPath.existsSync()) {
    printError("input path '${inputPath.path}' not found");
    return null;
  }

  final files = await _listFiles(inputPath);
  final translationFiles = <TranslationFile>[];

  for (final file in files) {
    final filename = path.basename(file.path);
    final filenameMatch = _matchesFilename(filename);

    if (filenameMatch != null) {
      final languageCode = filenameMatch.group(1);
      final countryCode = filenameMatch.group(2);
      translationFiles.add(TranslationFile(file, languageCode, countryCode));
      printInfo("Found translation file at '${file.path}'");
    }
  }

  return translationFiles;
}

Future<List<FileSystemEntity>> _listFiles(Directory dir) {
  final files = <FileSystemEntity>[];
  final completer = Completer<List<FileSystemEntity>>();
  final lister = dir.list(recursive: false);

  lister.listen(
    files.add,
    onDone: () => completer.complete(files),
    onError: completer.completeError,
  );

  return completer.future;
}

Match _matchesFilename(String filename) {
  return filenameRegex.firstMatch(filename);
}
