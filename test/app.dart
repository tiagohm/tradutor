import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../example/lib/i18n.dart';

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
        onLocaleChanged: (locale) {
          setState(() => _locale = locale);
        },
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
  final void Function(Locale locale) onLocaleChanged;

  const _HomePage({
    Key key,
    this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.simpleMessage),
      ),
      body: Center(
        child: Text(i18n.simpleMessageWithParameters('Tiago')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLanguage,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _changeLanguage() {
    var locale = I18n.locale$;

    if (locale.languageCode == 'en') {
      locale = const Locale('pt', 'BR');
    } else {
      locale = const Locale('en', 'US');
    }

    I18n.locale$ = locale;

    onLocaleChanged?.call(locale);
  }
}
