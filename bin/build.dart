import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:stream_transform/stream_transform.dart';
import 'package:tradutor/src/build.dart';
import 'package:tradutor/src/build_options.dart';
import 'package:tradutor/src/discovery.dart';
import 'package:tradutor/src/errors.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/parse.dart';
import 'package:tradutor/src/pen.dart';
import 'package:tradutor/src/translation_file.dart';

// flutter packages pub run tradutor:build

main(List<String> args) async {
  // Constroi o parser de argumentos.
  final parser = _buildArgParser();
  // Obtém os argumentos.
  final results = parser.parse(args);
  // Obtém as opções a partir dos argumentos.
  final options = _obtainBuildOptions(results);
  // Localiza os arquivos de tradução.
  final files = await discoveryTranslationFiles(options);

  await _build(files, options);

  if (options.watch) {
    // Windows só monitora pastas.
    final inputDir = Directory(
      path.normalize(Directory.current.path + "/" + options.source),
    );

    printInfo("watching files at '${inputDir.path}'");

    inputDir
        .watch()
        .transform(debounce(Duration(milliseconds: 1500)))
        .listen((modifiedFile) async {
      printInfo("file '${modifiedFile.path}' was modified");
      await _build(files, options);
    });
  }
}

Future<void> _build(
  List<TranslationFile> files,
  BuildOptions options,
) async {
  final languages = List<Language>();

  for (final file in files) {
    try {
      languages.add(await parseTranslationFile(file, options));
    } on ParseError catch (e) {
      printError("Error in file '${file.file.path}': ${e.message}");
    } catch (e) {
      printError("Error in file '${file.file.path}': $e");
    }
  }

  // Converte os idiomas em código Dart.
  final text = buildTranslationDartFile(languages, options);
  // Cria e escreve num arquivo.
  final current = Directory.current;
  final outputFile = File(path.normalize(current.path + "/" + options.output));
  await outputFile.writeAsString(text);

  printSuccess("Generated translation file to ${outputFile.path}");
}

ArgParser _buildArgParser() {
  final parser = ArgParser();

  parser.addOption("source", abbr: "s", defaultsTo: "/i18n");
  parser.addOption("output", abbr: "o", defaultsTo: "/lib/i18n.dart");
  parser.addOption("fallback", abbr: "f", defaultsTo: "en_US");

  parser.addFlag("watch");

  return parser;
}

BuildOptions _obtainBuildOptions(ArgResults results) {
  return BuildOptions(
    source: results["source"],
    output: results["output"],
    fallback: results["fallback"],
    watch: results["watch"],
  );
}
