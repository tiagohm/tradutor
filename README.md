A Flutter package that simplify the internationalizing process using JSON files. Extracts messages to generate Dart files with friendly way to access messages you need.

`String get translator => "tradutor";`

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
    tradutor: ^0.3.0
```

## Usage
Open a terminal inside your project directory and run the following command:

```
flutter packages pub run tradutor:build
```

All supported arguments:

* `--source "DIRECTORY PATH"` or `-s "DIRECTORY PATH"`: A source folder contains all JSON files (defaults to "./i18n");
* `--output "FILE PATH"` or `-o "FILE PATH"`: An output file contains all strings (defaults to "./lib/i18n.dart");
* `--fallback "LANGUAGE"` or `-f  "LANGUAGE"`:  Provides a default language, used when the translation for the current running system is not provided (defaults to "en_US");
* `--watch`: Watches the JSON files for edits and does rebuilds as necessary.
* `--class-name "NAME"` or `-c "NAME"`: Allows change the generated Dart class name (defaults to "I18n").

Full example: `flutter packages pub run tradutor:build -s "/i18n" -o "/lib/i18n.dart" -f "en_US" -c "I18n" --watch`

## JSON Files

Crete JSON files naming them with language code (lowercase) and country code (uppercase). Ex.: pt_BR.json, en_US.json, etc.

`en_US.json`
```json
{
    "simpleMessage": "This is a simple Message",
    "messageWithParameters": "Hi {name}, Welcome you!",
    "brazilFlagColors": ["Green", "Yellow", "Blue", "White"],
    "simpleWhiteCakeIngredients": [
        "{whiteSugar} cup white sugar",
        "{butter} cup butter",
        "{eggs} eggs",
        "{vanilla} teaspoons vanilla extract",
        "{flour} cups all-purpose flour",
        "{bakingPowder} teaspoons baking powder",
        "{milk} cup milk"
    ],
    "homePage": {
        "title": "Home Page"
    },
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
    "simpleWhiteCakeIngredients": [
        "{whiteSugar} cup white sugar",
        "{butter} cup butter",
        "{eggs} eggs",
        "{vanilla} teaspoons vanilla extract",
        "{flour} cups all-purpose flour",
        "{bakingPowder} teaspoons baking powder",
        "{milk} cup milk"
    ],
}
```

Generated Dart getter:
```dart
List<String> simpleWhiteCakeIngredients(
          bakingPowder, butter, eggs, flour, milk, vanilla, whiteSugar) =>
      [
        "${whiteSugar} cup white sugar",
        "${butter} cup butter",
        "${eggs} eggs",
        "${vanilla} teaspoons vanilla extract",
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

> The 'other' plural form must be provided.

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
class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.homePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              i18n.counter(_counter),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### Extending from another language

Use property `@extends` and a valid locale.

`pt_BR.json`
```json
{
    "@extends": "pt_PT",
    "counter.one": "Botão foi pressionado {quantity} vez",
    "counter.other": "Botão foi pressionado {quantity} vezes"
}
```

> You must override all plural forms for a specified message.

### Other language properties

* `@textDirection`: valid values are `ltr` (default) and `rtl`;
