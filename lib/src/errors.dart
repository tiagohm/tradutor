class ParseError extends Error {
  final String message;

  ParseError(this.message);

  String toString() => "Parse error: $message";
}
