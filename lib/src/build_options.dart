class BuildOptions {
  final String source;
  final String output;
  final String fallback;
  final bool watch;

  BuildOptions({
    this.source,
    this.output,
    this.fallback,
    this.watch = false,
  });
}
