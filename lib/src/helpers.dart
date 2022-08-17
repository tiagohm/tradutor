void _printColor(
  dynamic text, [
  int? color,
]) {
  if (color != null) {
    print('\u001b[${color}m$text\u001b[0m');
  } else {
    print(text);
  }
}

void printError(dynamic text) {
  _printColor(text, 31);
}

void printWarning(dynamic text) {
  _printColor(text, 33);
}

void printSuccess(dynamic text) {
  _printColor(text, 32);
}

void printInfo(dynamic text) {
  _printColor(text, 34);
}
