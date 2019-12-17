class ParseError extends Error {
  final String message;

  ParseError(this.message);

  @override
  String toString() => 'Parse error: $message';
}
