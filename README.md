A Flutter package that simplify the internationalizing process using JSON and YAML files. Extracts messages to generate Dart files with friendly way to access messages you need.

`String get translator => "tradutor";`

[![Pub](https://img.shields.io/pub/v/tradutor?color=blueviolet)](https://pub.dev/packages/tradutor)

## Features

* Simple messages.
* Messages with multiple parameters.
* List of simple messages.
* List of messages with multiple parameters.
* Supported message types:
  * Plural.
  * Date.
  * Numeric.
  * Map.
* Optional parameters support.
* JSON and YAML files.
* Nested messages support.
* Supports hot reload.

## Installation 

In `pubspec.yaml` add the following dependencies:

```yaml
dependencies: 
    flutter_localizations: 
        sdk: flutter 

dev_dependencies:
    tradutor: ^0.9.1
```

## Usage
Open a terminal inside your project directory and run the following command:

```
flutter pub run tradutor:generate
```

All supported arguments:

* `--source "DIRECTORY PATH"` or `-s "DIRECTORY PATH"`: A source folder contains all JSON/YAML files (defaults to "./i18n");
* `--output "FILE PATH"` or `-o "FILE PATH"`: An output file contains all strings (defaults to "./lib/i18n.dart");
* `--fallback "LANGUAGE"` or `-f  "LANGUAGE"`:  Provides a default language, used when the translation for the current running system is not provided (defaults to "en_US");
* `--watch`: Watches the JSON/YAML files for edits and does rebuilds as necessary.
* `--class-name "NAME"` or `-c "NAME"`: Allows change the generated Dart class name (defaults to "I18n").

Full example: `flutter packages pub run tradutor:build -s "/i18n" -o "/lib/i18n.dart" -f "en_US" -c "I18n" --watch`

## JSON Files
Crete JSON files naming them with language code (lowercase) and country code (uppercase). Ex.: `pt_BR.json`, `en_US.json`, etc.

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

## YAML Files
Crete YAML files naming them with language code (lowercase) and country code (uppercase). Ex.: `pt_BR.yaml`, `en_US.yaml`, etc.

```yaml
simpleMessage: これは簡単なメッセージです
messageWithParameters: "{name}様、ようこそ！"
brazilFlagColors:
- 緑
- 黄色
- 青い
- 白い
simpleWhiteCakeIngredients:
- "白砂糖{whiteSugar}カップ"
- "バター{butter}カップ"
- "卵{eggs}個"
- "バニラエッセンス小さじ{vanilla}"
- "薄力粉{flour}カップ"
- "小さじ{bakingPowder}杯のベーキングパウダー"
- "牛乳{milk}カップ"
homePage:
  title: ホームページ
counter.other: ボタンが{quantity}回クリックされた
```

## Nested messages

The messages can be nested. The final message name will be transformed to camelCase format (starting with a lower case character and capital for each later key).

```json
{
  "this" : {
    "is" : {
      "a": {
        "nested": "Message"
      }
    }
  }
}
```

Generated Dart getter:

```dart
String get thisIsANested => 'Message';
```

## Optional parameters

Use `{?name=value}` for set the parameter as optional. The `=value` is optional and will use an empty string when omitted.

## Supported Message Type

The all parameters in a message must be surrounded by curly braces. The parameters are sorted alphabetically.

### Simple message

```json
{ 
    "simpleMessage": "This is a simple Message"
}
```

Generated Dart getter:

```dart
String get simpleMessage => 'This is a simple Message';
```

### Message with parameters

```json
{
    "messageWithParameters": "Hi {name}, Welcome you!"
}
```

Generated Dart method:

```dart
String messageWithParameters(dynamic name) => 'Hi ${name}, Welcome you!';
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
List<String> get brazilFlagColors => ['Green', 'Yellow', 'Blue', 'White'];
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

Generated Dart method:

```dart
List<String> simpleWhiteCakeIngredients(
          dynamic bakingPowder, 
          dynamic butter, 
          dynamic eggs, 
          dynamic flour, 
          dynamic milk, 
          dynamic vanilla, 
          dynamic whiteSugar) =>
      [
        '${whiteSugar} cup white sugar',
        '${butter} cup butter',
        '${eggs} eggs',
        '${vanilla} teaspoons vanilla extract',
        '${flour} cups all-purpose flour',
        '${bakingPowder} teaspoons baking powder',
        '${milk} cup milk'
      ];
```

### Plural messages

The last message name must be `zero`, `one`, `two`, `few`, `many` or `other`. See [Language Plural Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html).

```json
{
  "counter.one": "Button clicked 1 time",
  "counter.other": "Button cliked {quantity} times"
}
```

Or

```json
{
  "counter": {
    "one": "Button clicked 1 time",
    "other": "Button cliked {quantity} times"
  }
}
```

> The 'other' plural form must be provided.

> `quantity` is the parameter used to format a message depending on its value.

Generated Dart method:

```dart
String counter(int quantity) => Intl.plural(
        quantity,
        locale: 'en_US',
        one: 'Button clicked 1 time',
        other: 'Button cliked ${quantity} times',
      );
```

### Map messages

The message name starts with `%`.

```json
{
  "%eyeColor": {
    "FAMALE": "She has {color} eyes",
    "MALE": "He has {color} eyes"
  }
}
```

Generated Dart method:

```dart
String eyeColor(String key, dynamic color) {
    switch (key) {
      case 'FAMALE':
        return 'She has ${color} eyes';
      case 'MALE':
        return 'He has ${color} eyes';
      default:
        return null;
    }
  }
```

> `key` is the parameter used to format a message depending on its value.

### Date messages

The message name starts with `#`.

```json
{
    "#fullDate": "MM dd, yyyy h:mm:ss a"
}
```

Generated Dart method:

```dart
static final _fullDateFormatter = DateFormat('MM dd, yyyy h:mm:ss a', 'en_US');
String fullDate(DateTime date) => _fullDateFormatter.format(date);
```

See the DateFormat documentation [here](https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html).

### Number messages

The message name starts with `$`.

```json
{
    "$currencyMessage": "\\$#,##0.00"
}
```

Generated Dart method:

```dart
static final _currencyMessageFormatter = NumberFormat('\$#,##0.00', 'en_US');
String currencyMessage(num number) => _currencyMessageFormatter.format(number);
```

See the NumberFormat documentation [here](https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html).

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
      home: const HomePage(),
      localizationsDelegates: [
        i18n,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: i18n.supportedLocales,
      localeResolutionCallback: i18n.resolution(
        fallback: const Locale('en', 'US'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _counter = 0;

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
        title: Text(i18n.homePage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(i18n.counter(_counter)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Escaping Curly Braces and Dollar Sign.

| Json | Dart | Message (a = 'Hi') | Note |
| :-: | :-: | :-: | :-: |
| "{a}" | "${a}" | "Hi" | Just a parameter |
| "\\\\{a}" | "\\{a}"  | "{a}" | Text surrounded by curly braces |
| "\\\\\\\\{a}"  | "\\\\{a}" | "\\{a}" | Backslash + text surrounded by curly braces |
| "\\\\{!a}" | "\\${a}" | "\\Hi" | Backslash + parameter |
| "\\\\{!?a}" | "\\${a}" | "\\Hi" | Backslash + optional parameter |
| "\\\\$"  | "\\$" | "$" | Just a dollar sign |

## Language Options

### @parent

Use `@parent` to indicate that language is a parent language.

`pt_PT.json`
```json
{
    "@parent": true,
}
```

`pt_PT` is parent language of `pt_BR`, `pt_AO`, `pt_TL`, etc. If some child language does not found, `pt_PT` will be used instead.

### @textDirection

Use `@textDirection` to indicate the direction in which text flows. The valid values are `ltr` (default) and `rtl`.

`he_IL.json`
```json
{
    "@textDirection": "rtl",
}
```
