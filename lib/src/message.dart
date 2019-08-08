/// Representa uma string ou lista de strings de tradução.
abstract class Message<T> implements Comparable<Message<T>> {
  final String key;
  final T value;

  Message(this.key, this.value);

  @override
  int compareTo(Message<T> other) => key.compareTo(other.key);

  @override
  String toString() {
    return "$runtimeType { key: $key, value: $value }";
  }
}

class StringMessage extends Message<String> {
  StringMessage(String key, String value) : super(key, value);
}

class ListMessage extends Message<List<String>> {
  ListMessage(String key, List<String> value) : super(key, value);
}

class PluralMessage implements Message<String> {
  final String type;
  final StringMessage message;

  PluralMessage(this.type, this.message);

  @override
  String get key => message.key;

  @override
  String get value => message.value;

  bool get list => message is ListMessage;

  bool get string => message is StringMessage;

  @override
  int compareTo(Message<String> other) => key.compareTo(other.key);

  @override
  String toString() {
    return "PluralMessage { type: $type, key: $key, value: $value }";
  }
}
