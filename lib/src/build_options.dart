import 'package:equatable/equatable.dart';

class BuildOptions extends Equatable {
  final String source;
  final String output;
  final String fallback;
  final bool watch;
  final String className;
  final bool isWeb;

  const BuildOptions({
    this.source = '/i18n',
    this.output = '/lib/i18n.dart',
    this.fallback = 'en_US',
    this.watch = false,
    this.className = 'I18n',
    this.isWeb = false,
  });

  @override
  List<Object> get props => [source, output, fallback, watch, className, isWeb];
}
