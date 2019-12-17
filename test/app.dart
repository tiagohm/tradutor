import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n.dart';

class App extends StatefulWidget {
  final Locale locale;

  const App({
    Key key,
    this.locale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  Locale _locale;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.delegate;

    return MaterialApp(
      title: 'App',
      home: _HomePage(
        localeChanged: (locale) => setState(() => _locale = locale),
      ),
      localizationsDelegates: [
        i18n,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale ?? widget.locale,
      supportedLocales: i18n.supportedLocales,
      localeResolutionCallback:
          i18n.resolution(fallback: const Locale('en', 'US')),
    );
  }
}

class _HomePage extends StatelessWidget {
  final void Function(Locale locale) localeChanged;

  const _HomePage({
    Key key,
    this.localeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.homePageTitle),
      ),
      body: Center(
        child: Text(i18n.simpleMessage),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _changeLanguage,
      ),
    );
  }

  void _changeLanguage() {
    var locale = I18n.locale;

    if (locale.languageCode == 'en') {
      locale = const Locale('pt', 'BR');
    } else {
      locale = const Locale('en', 'US');
    }

    I18n.locale = locale;

    localeChanged?.call(locale);
  }
}
