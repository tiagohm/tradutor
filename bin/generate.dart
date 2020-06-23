import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;
import 'package:stream_transform/stream_transform.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/tradutor.dart';
import 'package:tradutor/src/yaml.dart';

// flutter packages pub run tradutor:generate

final Tradutor tradutor = Tradutor();

void main(List<String> args) async {
  // Constroi o parser de argumentos.
  final parser = _buildArgParser();
  // Obtém os argumentos.
  final results = parser.parse(args);
  // Obtém as opções a partir dos argumentos.
  final options = _obtainBuildOptions(results);

  _discovery(options);

  if (options.watch) {
    // Windows só monitora pastas.
    final inputDir = Directory(
      path.normalize('${Directory.current.path}/${options.source}'),
    );

    print('Watching files at "${inputDir.path}"');

    inputDir
        .watch()
        .debounce(const Duration(milliseconds: 3000))
        .listen((event) {
      final file = File(event.path);

      if (event.type == FileSystemEvent.create ||
          event.type == FileSystemEvent.modify) {
        _fileFound(file, options);
      } else {
        _fileDeleted(file, options);
      }
    });
  }
}

void _build(
  String input,
  Language language,
  String ext,
  BuildOptions options, {
  bool immediately = true,
}) {
  final data = ext == 'json' ? json.decode(input) : yaml.decode(input);
  tradutor.read(data, language);

  if (immediately) {
    // Converte os idiomas em código Dart.
    final text = tradutor.text();
    // Cria e escreve num arquivo.
    final current = Directory.current;
    final outputFile =
        File(path.normalize('${current.path}/${options.output}'));
    outputFile.writeAsStringSync(text);
    print('Generated dart file to ${outputFile.path}');
  }
}

ArgParser _buildArgParser() {
  return ArgParser()
    ..addOption('source', abbr: 's', defaultsTo: '/i18n')
    ..addOption('output', abbr: 'o', defaultsTo: '/lib/i18n.dart')
    ..addOption('fallback', abbr: 'f', defaultsTo: 'en_US')
    ..addOption('classname', abbr: 'c', defaultsTo: 'I18n')
    ..addFlag('web')
    ..addFlag('watch');
}

BuildOptions _obtainBuildOptions(ArgResults results) {
  return BuildOptions(
    source: results['source'] as String,
    output: results['output'] as String,
    fallback: results['fallback'] as String,
    watch: results['watch'] as bool,
    className: results['classname'] as String,
    isWeb: results['web'] as bool,
  );
}

void _discovery(BuildOptions options) async {
  final current = Directory.current;

  final inputPath =
      Directory(path.normalize('${current.path}/${options.source}'));

  if (!inputPath.existsSync()) {
    print("Input path '${inputPath.path}' not found");
    return null;
  }

  final files = await _list(inputPath);

  for (var i = 0; i < files.length; i++) {
    _fileFound(files[i], options, immediately: i == files.length - 1);
  }
}

void _fileDeleted(
  File file,
  BuildOptions options,
) {
  final ext = path.extension(file.path)?.toLowerCase();
  final language = path.basenameWithoutExtension(file.path);

  if (file is File &&
      (ext == '.json' || ext == '.yaml' || ext == '.yml') &&
      Language.matches(language)) {
    final code = language.substring(0, 2);
    final country = language.substring(3);
    final locale = Language(code, country);

    if (tradutor.removeLanguage(locale)) {
      _build(
        file.readAsStringSync(),
        locale,
        ext.substring(1),
        options,
      );
    }
  }
}

void _fileFound(
  File file,
  BuildOptions options, {
  bool immediately = false,
}) {
  final ext = path.extension(file.path)?.toLowerCase();
  final language = path.basenameWithoutExtension(file.path);

  if (file is File &&
      (ext == '.json' || ext == '.yaml' || ext == '.yml') &&
      Language.matches(language)) {
    print("Found translation file at '${file.path}'");

    _build(
      file.readAsStringSync(),
      Language.parse(language),
      ext.substring(1),
      options,
      immediately: immediately,
    );
  }
}

Future<List<FileSystemEntity>> _list(Directory dir) {
  final files = <FileSystemEntity>[];
  final completer = Completer<List<FileSystemEntity>>();
  final lister = dir.list(recursive: false);

  lister.listen(
    files.add,
    onDone: () => completer.complete(files),
    onError: completer.completeError,
    cancelOnError: true,
  );

  return completer.future;
}

class BuildOptions extends Equatable {
  final String source;
  final String output;
  final String fallback;
  final bool watch;
  final String className;
  final bool isWeb;

  const BuildOptions({
    this.source = '/i18n',
    this.output = '/lib/i18n.dart',
    this.fallback = 'en_US',
    this.watch = false,
    this.className = 'I18n',
    this.isWeb = false,
  });

  @override
  List<Object> get props => [source, output, fallback, watch, className, isWeb];
}
