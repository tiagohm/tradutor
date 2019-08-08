import 'package:ansicolor/ansicolor.dart';

final red = AnsiPen()..red();
final blue = AnsiPen()..blue();
final yellow = AnsiPen()..yellow();
final green = AnsiPen()..green();
final white = AnsiPen()..white();

void printError(msg) => print(red(msg?.toString()));
void printWarning(msg) => print(yellow(msg?.toString()));
void printInfo(msg) => print(blue(msg?.toString()));
void printSuccess(msg) => print(green(msg?.toString()));
