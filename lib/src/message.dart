import 'package:equatable/equatable.dart';

final _paramRegex = RegExp(r'(?<!{){([a-z][a-z0-9_]*)}', caseSensitive: false);

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
    final params = <MessageParameter>[];

    var pos = 0;

    while (true) {
      try {
        final match = _paramRegex.allMatches(value, pos)?.first;
        if (match == null) break;
        final name = match.group(1);
        params.add(MessageParameter(name, dynamic));
        final textToReplace = '\${$name}';
        value = value.replaceRange(match.start, match.end, textToReplace);
        pos = match.start + textToReplace.length;
      } catch (e) {
        break;
      }
    }

    return [
      value.replaceAll('{{', '{').replaceAll('}}', '}'),
      MessageParameterList(params),
    ];
  }

  @override
  String get value => _value;

  @override
  MessageParameterList get parameters => _parameters;
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
      var value = values[i];
      var pos = 0;

      while (true) {
        try {
          final match = _paramRegex.allMatches(value, pos)?.first;
          if (match == null) break;
          final name = match.group(1);
          params.add(MessageParameter(name, dynamic));
          final textToReplace = '\${$name}';
          value = value.replaceRange(match.start, match.end, textToReplace);
          pos = match.start + textToReplace.length;
        } catch (e) {
          break;
        }
      }

      res.add(value.replaceAll('{{', '{').replaceAll('}}', '}'));
    }

    return [res, MessageParameterList(params)];
  }

  @override
  List<String> get value => _value;

  @override
  MessageParameterList get parameters => _parameters;
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

  bool get isList => message is ListMessage;

  bool get isSimple => message is SimpleMessage;

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
      MessageParameterList(
          [for (final p in params) if (p.name != 'quantity') p]),
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

class OptionMessage extends SimpleMessage {
  OptionMessage(String key, String value) : super(key, value);

  @override
  List init(String value) {
    return [value, MessageParameterList.empty];
  }
}
