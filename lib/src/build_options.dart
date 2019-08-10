class BuildOptions {
  final String source;
  final String output;
  final String fallback;
  final bool watch;
  final String className;

  BuildOptions({
    this.source = "/i18n",
    this.output = "/lib/i18n.dart",
    this.fallback = "en_US",
    this.watch = false,
    this.className = "I18n",
  });
}
