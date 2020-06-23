import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tradutor/src/language.dart';
import 'package:tradutor/src/tradutor.dart';

void main() {
  test('Build', () {
    final parser = Tradutor();

    final en = File('./example/i18n/en_US.json').readAsStringSync();
    parser.read(json.decode(en), Language('en', 'US'));
    final br = File('./example/i18n/pt_BR.json').readAsStringSync();
    parser.read(json.decode(br), Language('pt', 'BR'));
    final pt = File('./example/i18n/pt_PT.json').readAsStringSync();
    parser.read(json.decode(pt), Language('pt', 'PT'));

    print(parser.text());
  });

  test('Camelize', () {
    expect(Tradutor.camelize('abc-def_-_ghi.one'), 'abcDefGhiOne');
  });

  test('Remove Plural Type', () {
    expect(Tradutor.removePluralTypeFromKey('a.one'), 'a');
    expect(Tradutor.removePluralTypeFromKey('a.many'), 'a');
    expect(Tradutor.removePluralTypeFromKey('a.other'), 'a');
    expect(Tradutor.removePluralTypeFromKey('ab'), 'ab');
  });
}
