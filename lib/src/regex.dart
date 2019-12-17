final pluralKeyRegex = RegExp(
  r'^([a-z][a-z0-9]+)\.(zero|one|two|few|many|other)$',
  caseSensitive: false,
);
final keyRegex = RegExp(r'^([a-z][a-z0-9]*)$', caseSensitive: false);
final optionKeyRegex = RegExp(r'^@([a-z][a-z0-9]*)$', caseSensitive: false);
final dateKeyRegex = RegExp(r'^#([a-z][a-z0-9]*)$', caseSensitive: false);
final paramRegex = RegExp(r'(?<!\$){([a-z][a-z0-9]*)}', caseSensitive: false);
final filenameRegex = RegExp(r'([a-z]{2})_([A-Z]{2})\.(json|yaml)$');
final localeRegex = RegExp(r'^([a-z]{2})_([A-Z]{2})$');
