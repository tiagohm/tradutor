import 'package:ansicolor/ansicolor.dart';

final red = AnsiPen()..red();
final blue = AnsiPen()..blue();
final yellow = AnsiPen()..yellow();
final green = AnsiPen()..green();
final white = AnsiPen()..white();

void printError(dynamic msg) => print(red(msg?.toString()));
void printWarning(dynamic msg) => print(yellow(msg?.toString()));
void printInfo(dynamic msg) => print(blue(msg?.toString()));
void printSuccess(dynamic msg) => print(green(msg?.toString()));
