A Flutter package that simplify the internationalizing process using JSON files. Extracts messages to generate Dart files with friendly way to access messages you need.

[![Pub](https://img.shields.io/pub/v/tradutor?color=blueviolet)](https://pub.dev/packages/tradutor)

## Features

* Simple messages;
* Messages with multiple parameters;
* List of simple messages;
* List of messages with multiple parameters;
* Plural messages;
* Allow a language extends another language;
* Supports hot reload;

## Installation 

In `pubspec.yaml` add the following dependencies:

```yaml
dependencies: 
    flutter_localizations: 
        sdk: flutter 

dev_dependencies:
    tradutor: 0.1.0
```

## Usage
Open a terminal inside your project directory and run the following command:

```
flutter packages pub run tradutor:build
```

All supported arguments:

* `--source [DIRECTORY PATH]` or `-s [DIRECTORY PATH]`: A source folder contains all JSON files (defaults to "/i18n");
* `--output [FILE PATH]` or `-o [FILE PATH]`: An output file contains all strings (defaults to "/lib/i18n.dart");
* `--fallback [LANGUAGE]` or `-f  [LANGUAGE]`:  Provides a default language, used when the translation for the current running system is not provided (defaults to "en_US");
* `--watch`: Watches the JSON files for edits and does rebuilds as necessary.

Full example: `flutter packages pub run tradutor:build -s "/i18n" -o "/lib/i18n.dart" -f "en_US" --watch`

## JSON Files

Crete JSON files naming them with language code (lowercase) and country code (uppercase). Ex.: pt_BR.json, en_US.json, etc.

`en_US.json`
```json
{
    "simpleMessage": "This is a simple Message",
    "messageWithParameters": "Hi {name}, Welcome you!",
    "brazilFlagColors": ["Green", "Yellow", "Blue"],
    "simpleWhiteCakeReceipt": [
        "{whiteSugar} cup white sugar",
        "{butter} cup butter",
        "{eggs} eggs",
        "{vanilla} teasspoons vanilla extract",
        "{flour} cups all-purpose flour",
        "{bakingPowder} teaspoons baking powder",
        "{milk} cup milk"
    ],
    "homePageTitle": "Home Page",
    "counter.one": "Button clicked 1 time",
    "counter.other": "Button cliked {quantity} times"
}
```

## Supported Message Type

### Simple message

```json
{ 
    "simpleMessage": "This is a simple Message"
}
```

Generated Dart getter:
```dart
String get simpleMessage => "This is a simple Message";
```

### Message with parameters

Use `{parameterName}` in a message.
```json
{
    "messageWithParameters": "Hi {name}, Welcome you!"
}
```

Generated Dart method:
```dart
String messageWithParameters(name) => "Hi $name, Welcome you!";
```

### List of simple messages

Define an array of strings.

```json
{
    "brazilFlagColors": ["Green", "Yellow", "Blue", "White"]
}
```

Generated Dart getter:
```dart
List<String> get brazilFlagColors => ["Green", "Yellow", "Blue", "White"];
```

### List of messages with multiple parameters

```json
{
    "simpleWhiteCakeReceipt": [
        "{whiteSugar} cup white sugar",
        "{butter} cup butter",
        "{eggs} eggs",
        "{vanilla} teasspoons vanilla extract",
        "{flour} cups all-purpose flour",
        "{bakingPowder} teaspoons baking powder",
        "{milk} cup milk"
    ],
}
```

Generated Dart getter:
```dart
List<String> simpleWhiteCakeReceipt(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        "${whiteSugar} cup white sugar",
        "${butter} cup butter",
        "${eggs} eggs",
        "${vanilla} teasspoons vanilla extract",
        "${flour} cups all-purpose flour",
        "${bakingPowder} teaspoons baking powder",
        "${milk} cup milk"
      ];
```

### Plural messages

```json
{
    "counter.one": "Button clicked 1 time",
    "counter.other": "Button cliked {quantity} times"
}
```

Generated Dart method:
```dart
String counter(quantity) => Intl.plural(
        quantity,
        locale: locale,
        one: "Button clicked 1 time",
        other: "Button cliked ${quantity} times",
      );
```

### Usage of Generated Dart file (i18n.dart)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final i18n = I18n.delegate;

    return MaterialApp(
        title: 'Tradutor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        localizationsDelegates: [
          i18n,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: i18n.supportedLocales,
        localeResolutionCallback:
            i18n.resolution(fallback: Locale("en", "US")));
  }
}
```

```dart
final i18n = I18n.of(context);
i18n.homePageTitle;
i18n.counter(_counter);
```
