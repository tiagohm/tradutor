import 'dart:convert';

import 'package:yaml/yaml.dart';

const YamlCodec yaml = YamlCodec();

class YamlCodec extends Codec<Object, String> {
  const YamlCodec();

  @override
  Converter<String, Object> get decoder => const YamlDecoder();

  @override
  Converter<Object, String> get encoder => throw UnimplementedError();
}

class YamlDecoder extends Converter<String, Object> {
  const YamlDecoder();

  @override
  Object convert(String input) {
    final doc = loadYaml(input);
    final text = json.encode(doc);
    return json.decode(text);
  }
}
