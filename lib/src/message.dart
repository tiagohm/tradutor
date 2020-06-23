import 'package:code_builder/code_builder.dart';
import 'package:equatable/equatable.dart';

final _paramRegex = RegExp(r'(?<!\\){([a-z][a-z0-9_]*)}', caseSensitive: false);
final _forcedParamRegex =
    RegExp(r'(?<=\\){!([a-z][a-z0-9_]*)}', caseSensitive: false);
final _paramRegexList = [_paramRegex, _forcedParamRegex];
final _escapeBracesRegex = RegExp(r'(?<!\\)\\{');

List _fetchParameters(
  final String text, {
  final int start = 0,
  final bool replace = true,
}) {
  var value = text;
  final params = <MessageParameter>[];

  for (final regex in _paramRegexList) {
    var pos = start;
    final isForced = regex == _forcedParamRegex;

    while (true) {
      try {
        final match = regex.allMatches(value, pos)?.first;

        final name = match.group(1);
        params.add(MessageParameter(name, dynamic));

        if (replace) {
          final textToReplace = isForced ? '\\\${$name}' : '\${$name}';
          value = value.replaceRange(match.start, match.end, textToReplace);
          pos = match.start + textToReplace.length;
        } else {
          pos = match.end;
        }
      } catch (e) {
        break;
      }
    }
  }

  params.sort((a, b) => a.name.compareTo(b.name));

  if (replace) {
    value = value.replaceAll(_escapeBracesRegex, '{');
  }

  return [value, params];
}

class MessageParameterList extends Iterable<MessageParameter>
    with EquatableMixin {
  final List<MessageParameter> parameters;

  static final MessageParameterList empty = MessageParameterList(const []);

  MessageParameterList(this.parameters);

  @override
  String toString() {
    return parameters?.toString();
  }

  @override
  List<Object> get props => parameters;

  @override
  Iterator<MessageParameter> get iterator => parameters.iterator;
}

class MessageParameter extends Equatable {
  final String name;
  final Type type;
  final bool isOptional;
  final String value;

  const MessageParameter(
    this.name,
    this.type, {
    this.isOptional = false,
    this.value,
  });

  @override
  List<Object> get props => [name, type, isOptional, value];

  @override
  String toString() {
    return 'Parameter { name: $name, type: $type, value: $value }';
  }
}

abstract class Message<T> implements Comparable<Message<T>> {
  String get key;

  T get value;

  MessageParameterList get parameters;

  @override
  int compareTo(Message<T> other) => key.compareTo(other.key);

  Expression get expression;

  @override
  String toString() {
    return '$runtimeType { key: $key, value: $value }';
  }
}

class SimpleMessage extends Message<String> {
  @override
  final String key;
  MessageParameterList _parameters;
  String _value;
  final String raw;

  SimpleMessage(this.key, this.raw) {
    final res = init(raw);
    _value = res[0];
    _parameters = res[1];
  }

  List init(String value) {
    final data = _fetchParameters(value);

    return [
      data[0],
      MessageParameterList(data[1]),
    ];
  }

  @override
  String get value => _value;

  @override
  MessageParameterList get parameters => _parameters;

  @override
  Expression get expression {
    return literalString(value);
  }
}

class ListMessage extends Message<List<String>> {
  final String key;
  List<String> _value;
  MessageParameterList _parameters;

  ListMessage(this.key, List<String> values) {
    final res = init(values);
    _value = res[0];
    _parameters = res[1];
  }

  List init(List<String> values) {
    final params = <MessageParameter>[];
    final res = <String>[];

    for (var i = 0; i < values.length; i++) {
      final data = _fetchParameters(values[i]);
      res.add(data[0]);
      params.addAll(data[1]);
    }

    params.sort((a, b) => a.name.compareTo(b.name));

    return [res, MessageParameterList(params)];
  }

  @override
  List<String> get value => _value;

  @override
  MessageParameterList get parameters => _parameters;

  @override
  Expression get expression {
    return literalList(value);
  }
}

enum PluralType { zero, one, two, few, many, other }

String pluralName(PluralType type) {
  switch (type) {
    case PluralType.zero:
      return 'zero';
    case PluralType.one:
      return 'one';
    case PluralType.two:
      return 'two';
    case PluralType.few:
      return 'few';
    case PluralType.many:
      return 'many';
    default:
      return 'other';
  }
}

class PluralMessage extends SimpleMessage {
  final PluralType type;
  final SimpleMessage message;

  PluralMessage(this.type, this.message) : super(message.key, message.raw);

  @override
  String toString() {
    return 'PluralMessage { type: $type, key: $key, value: $value }';
  }

  @override
  List init(String value) {
    final res = super.init(value);
    final MessageParameterList params = res[1];

    return [
      res[0],
      MessageParameterList([
        for (final p in params)
          if (p.name != 'quantity') p
      ]),
    ];
  }
}

class DateMessage extends SimpleMessage {
  DateMessage(String key, String value) : super(key, value);

  @override
  List init(String value) {
    return [value, MessageParameterList.empty];
  }
}

class NumberMessage extends SimpleMessage {
  NumberMessage(String key, String value) : super(key, value);

  @override
  List init(String value) {
    return [value, MessageParameterList.empty];
  }
}

class MapMessage extends SimpleMessage {
  final String type;
  final SimpleMessage message;

  MapMessage(this.type, this.message) : super(message.key, message.raw);

  @override
  String toString() {
    return 'MapMessage { type: $type, key: $key, value: $value }';
  }
}

class OptionMessage extends SimpleMessage {
  OptionMessage(String key, String value) : super(key, value);

  @override
  List init(String value) {
    return [value, MessageParameterList.empty];
  }
}
