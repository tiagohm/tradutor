A Flutter package that simplify the internationalizing process using JSON files. Extracts messages to generate Dart files with friendly way to access messages you need.

[![Pub](https://img.shields.io/pub/v/tradutor?color=blueviolet)](https://pub.dev/packages/tradutor)

## Features

* Simple messages;
* Messages with multiple parameters;
* 

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

Crete JSON files naming with language code and country code. Ex.: pt_BR.json, en_US.json, etc.

`en_US.json`
```json
{
    "simpleMessage": "This is a simple message",
    "messageWithParams": "Hi {name}, welcome you!",
    "pluralMessage.One": "Hi {name}, I have one year working experience.",
    "pluralMessage.Other": "Hi {name}, I have {quantity} years of working experience.",
    "arrayMessage": [
        "White",
        "Blue",
        "Yellow"
    ],
    "message.one": "Button clicked 1 time",
    "message.other": "Button clicked {quantity} times"    
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
    "colors": ["Green", "Yellow", "Blue"]
}
```

Generated Dart getter:
```dart
List<String> get colors => ["Green", "Yellow", "Blue"];
```

### List of messages with parameters

```json
{
    "colors": ["Green", "Yellow", "Blue"]
}
```

Generated Dart getter:
```dart
List<String> get colors => ["Green", "Yellow", "Blue"];
```
