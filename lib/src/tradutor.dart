import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'language.dart';
import 'message.dart';

class Tradutor {
  final _items = <Language, Map<String, dynamic>>{};
  final _messages = <Language, List<Message>>{};
  final Language fallback;

  final _languages = <Language, Class>{};
  List<Code> _constants;
  Class _fallback;
  Class _delegate;
  final _textDirection = <Language, String>{};
  final _parent = <String, Language>{};

  static final _keyRegex = RegExp(r'^[@#$]?[a-zA-Z][\w.-]*$');
  static final _camelizeRegex = RegExp('[^a-zA-Z0-9]+');

  static const _header = '''
    import 'package:flutter/foundation.dart';
    import 'package:flutter/widgets.dart';
    import 'package:intl/intl.dart' hide TextDirection;

    // ignore_for_file: camel_case_types
    // ignore_for_file: non_constant_identifier_names
    // ignore_for_file: unnecessary_brace_in_string_interps
    // ignore_for_file: unused_import
    // ignore_for_file: annotate_overrides
    // ignore_for_file: avoid_annotating_with_dynamic
    // ignore_for_file: implicit_dynamic_parameter

    // See more about language plural rules: https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html

   ''';

  Tradutor({String fallback = 'en_US'})
      : assert(fallback != null),
        fallback = Language.parse(fallback) {
    _fallback = _buildFallback(this.fallback);
  }

  void read(
    dynamic items,
    Language language,
  ) {
    if (items is Map<String, dynamic>) {
      _items[language]?.clear();
      _items[language] ??= <String, dynamic>{};
      _parse(language, items);
      _analyse(language);
      _loadOptions(language);
      _build(language);
    } else {
      throw ParseError('Invalid file format', language);
    }
  }

  String text() {
    final emitter = DartEmitter();
    final formatter = DartFormatter();

    final text = <Spec>[
      ..._constants,
      _fallback,
      ..._languages.values,
      _delegate,
    ].map((c) => c.accept(emitter)).join();

    return formatter.format(_header + text);
  }

  void _parse(
    Language language,
    Map<String, dynamic> items, [
    String parentKey,
  ]) {
    items?.forEach((key, value) {
      // Key.
      final itemKey = parentKey == null ? key : '$parentKey.$key';
      // Null or Empty.
      if (value == null || value == '') {
        // nada.
      }
      // Primitive.
      else if (value is num || value is bool || value is String) {
        _items[language][itemKey] = '$value';
      }
      // List of Primitives.
      else if (value is List) {
        final list = <String>[];

        for (final item in value) {
          if (item is num || item is bool || item is String) {
            list.add('$item');
          } else {
            throw ParseError.invalidType(key, item, language);
          }
        }

        _items[language][itemKey] = list;
      }
      // Map.
      else if (value is Map) {
        _parse(language, value, itemKey);
      }
      // Unknown.
      else {
        throw ParseError.invalidType(key, value, language);
      }
    });
  }

  void _analyse(Language language) {
    _messages[language]?.clear();
    _messages[language] ??= <Message>[];

    for (final key in keys(language)) {
      if (_keyRegex.firstMatch(key) == null) {
        throw ParseError.invalidKey(key, language);
      }

      final res = value(language, key);

      // Option.
      if (key.startsWith('@')) {
        if (res is num || res is bool || res is String) {
          _messages[language].add(OptionMessage(key.substring(1), res));
          continue;
        } else {
          throw ParseError.invalidType(key, res, language);
        }
      }
      // Date.
      if (key.startsWith('#')) {
        if (res is String) {
          _messages[language].add(DateMessage(key.substring(1), res));
          continue;
        } else {
          throw ParseError.invalidType(key, res, language);
        }
      }
      // Number.
      if (key.startsWith('\$')) {
        if (res is String) {
          _messages[language].add(NumberMessage(key.substring(1), res));
          continue;
        } else {
          throw ParseError.invalidType(key, res, language);
        }
      }
      // Plural.
      final type = pluralTypeFromKey(key.toLowerCase());

      if (type != null) {
        if (res is num || res is bool || res is String) {
          final message = SimpleMessage(removePluralTypeFromKey(key), '$res');
          _messages[language].add(PluralMessage(type, message));
          continue;
        } else {
          throw ParseError.invalidType(key, res, language);
        }
      }
      // List.
      if (res is List<String>) {
        _messages[language].add(ListMessage(key, res));
        continue;
      }
      // Simple.
      _messages[language].add(SimpleMessage(key, '$res'));
    }
  }

  void _loadOptions(Language language) {
    for (final m in _messages[language]) {
      if (m is OptionMessage) {
        if (m.key == 'textDirection') {
          if (m.value == 'ltr' || m.value == 'rtl') {
            _textDirection[language] = m.value;
            continue;
          }
        } else if (m.key == 'parent') {
          if (m.value == 'true') {
            if (_parent.containsKey(language.code)) {
              throw ParseError('Duplicate parent language', language);
            }

            _parent[language.code] = language;
          }

          continue;
        }

        throw ParseError.invalidValue(m.key, m.value, language);
      }
    }
  }

  void _build(Language language) {
    final messages = <String, dynamic>{};

    // Preenche com o idioma fallback.
    for (final m in _messages[fallback]) {
      // Plural.
      if (m is PluralMessage) {
        // Já existe a chave mas ela não é dos plurais.
        if (messages.containsKey(m.key) && messages[m.key] is! List) {
          throw ParseError('Duplicate key ${m.key}', fallback);
        }
        // Cria a lista de plurais, se necessário.
        messages[m.key] ??= <PluralMessage>[];
        // Adiciona a mensagem.
        messages[m.key].add(m);
      }
      // Simple, Date, Option, List, caso não exista ainda.
      else if (!messages.containsKey(m.key)) {
        messages[m.key] = m;
      }
      // Chave duplicada.
      else {
        throw ParseError('Duplicate key ${m.key}', fallback);
      }
    }

    // Preenche com o idioma.
    for (final m in _messages[language]) {
      // Option.
      if (m is OptionMessage) {
        continue;
      }
      // A chave não está presente no idioma de fallback.
      if (!messages.containsKey(m.key)) {
        throw ParseError('Key ${m.key} is not present in fallback', language);
      }
      // Plural.
      if (m is PluralMessage) {
        // Substituir o plural de mesmo tipo.
        final index = messages[m.key]
            .indexWhere((pm) => (pm as PluralMessage).type == m.type);
        // O tipo foi encontrado.
        if (index >= 0) {
          // Substitui.
          messages[m.key][index] = m;
        } else {
          // Caso contrário, adiciona.
          messages[m.key].add(m);
        }
      }
      // Substitui uma mensagem do idioma de fallback.
      // Deve existir uma e seu tipo deve ser compatível.
      // Deve ter os mesmos parâmetros.
      // TODO: Futuramente poderá um idioma possuir parâmetros
      // mas seu fallback não?
      else if (messages[m.key]?.runtimeType == m.runtimeType &&
          messages[m.key].parameters == m.parameters) {
        messages[m.key] = m;
      }
      // Tentando adicionar a mesma chave.
      // Ou os tipos não batem.
      else {
        throw ParseError('Duplicate or invalid key ${m.key}', language);
      }
    }

    _languages[language] = _buildClass(messages, language);
    _delegate = _buildDelegate();
    _constants = _buildConstants();
  }

  Class _buildClass(
    Map<String, dynamic> messages,
    Language language,
  ) {
    final isFallback = language == fallback;
    final name = isFallback ? 'I18n' : '_I18n_$language';

    // Options.
    final textDirection =
        _textDirection[language] ?? _textDirection[fallback] ?? 'ltr';

    return Class((c) {
      c.name = name;
      // Implements.
      if (isFallback) {
        c.implements.add(refer('WidgetsLocalizations'));
      } else {
        c.extend = refer('I18n');
      }
      // Constructors.
      c.constructors.add(
        Constructor((co) {
          co.constant = true;
        }),
      );
      // Field.
      c.fields.addAll([
        if (isFallback)
          Field((f) {
            f.static = true;
            f.name = '_locale';
            f.type = refer('Locale');
          }),
        if (isFallback)
          Field((f) {
            f.static = true;
            f.name = '_shouldReload';
            f.type = refer('bool');
            f.assignment = Code('false');
          }),
        if (isFallback)
          Field((f) {
            f.static = true;
            f.modifier = FieldModifier.constant;
            f.name = 'delegate';
            f.type = refer('GeneratedLocalizationsDelegate');
            f.assignment = refer('GeneratedLocalizationsDelegate')
                .newInstance(const []).code;
          }),
      ]);
      // Getters & Setters & Methods.
      c.methods.addAll([
        if (isFallback)
          Method((m) {
            m.static = true;
            m.name = 'locale\$';
            m.type = MethodType.getter;
            m.lambda = true;
            m.returns = refer('Locale');
            m.body = Code('_locale');
          }),
        if (isFallback)
          Method((m) {
            m.static = true;
            m.name = 'locale\$';
            m.type = MethodType.setter;
            m.requiredParameters.add(Parameter((p) {
              p.name = 'locale';
              p.type = refer('Locale');
            }));
            m.body = Block.of([
              refer('_shouldReload').assign(refer('true')).statement,
              refer('_locale').assign(refer('locale')).statement,
            ]);
          }),
        Method((m) {
          m.type = MethodType.getter;
          m.name = 'textDirection';
          m.returns = refer('TextDirection');
          m.lambda = true;
          m.body = Code('TextDirection.$textDirection');
        }),
        if (isFallback)
          Method((m) {
            m.static = true;
            m.name = 'of';
            m.lambda = true;
            m.returns = refer('I18n');
            m.requiredParameters.addAll([
              Parameter((p) {
                p.name = 'context';
                p.type = refer('BuildContext');
              }),
            ]);
            m.body = refer('Localizations.of<I18n>').call([
              refer('context'),
              refer('WidgetsLocalizations'),
            ]).code;
          }),
      ]);

      final keys = List.of(messages.keys)..sort();

      // Mensagens.
      for (final key in keys) {
        final message = messages[key];
        List m;

        // Plural.
        if (message is List) {
          m = _buildPluralMessage(message, language);
        }
        // Option.
        else if (message is OptionMessage) {
        }
        // Date.
        else if (message is DateMessage) {
          m = _buildDateMessage(message, language);
        }
        // Number.
        else if (message is NumberMessage) {
          m = _buildNumberMessage(message, language);
        }
        // List.
        else if (message is ListMessage) {
          m = _buildListMessage(message);
        }
        // Simple.
        else if (message is SimpleMessage) {
          m = _buildSimpleMessage(message);
        }

        if (m != null && m.isNotEmpty) {
          for (final a in m) {
            if (a is Method) {
              c.methods.add(a);
            } else if (a is Field) {
              c.fields.add(a);
            }
          }
        }
      }
    });
  }

  Class _buildFallback(Language language) {
    return Class((c) {
      c.name = '_I18n_$language';
      c.extend = refer('I18n');
      // Constructors.
      c.constructors.add(
        Constructor((co) {
          co.constant = true;
        }),
      );
    });
  }

  List<Code> _buildConstants() {
    return [
      for (final language in _languages.keys)
        refer('_I18n_$language')
            .newInstance(const [])
            .assignConst('$language'.replaceAll('_', ''), refer('I18n'))
            .statement,
    ];
  }

  Class _buildDelegate() {
    if (!_parent.containsKey(fallback.code)) {
      _parent[fallback.code] = fallback;
    }

    return Class((c) {
      c.name = 'GeneratedLocalizationsDelegate';
      c.extend = refer('LocalizationsDelegate<WidgetsLocalizations>');
      // Constructors.
      c.constructors.add(
        Constructor((co) {
          co.constant = true;
        }),
      );
      // Methods.
      c.methods.addAll([
        Method((m) {
          m.name = 'supportedLocales';
          m.returns = refer('List<Locale>');
          m.type = MethodType.getter;
          m.body = literalConstList([
            for (final l in _languages.keys)
              refer('Locale')
                  .newInstance([literal(l.code), literal(l.country)]),
          ]).code;
        }),
        Method((m) {
          m.name = 'resolution';
          m.returns = refer('LocaleResolutionCallback');
          m.optionalParameters.add(Parameter((p) {
            p.name = 'fallback';
            p.type = refer('Locale');
            p.named = true;
          }));
          m.body = Code('''
            return (locale, supported) {
              return isSupported(locale) ? locale : (fallback ?? supported.first);
            };
          ''');
        }),
        Method((m) {
          m.name = 'load';
          m.returns = refer('Future<WidgetsLocalizations>');
          m.requiredParameters.add(Parameter((p) {
            p.name = 'locale';
            p.type = refer('Locale');
          }));
          m.body = Block.of([
            refer('I18n._locale').assignNullAware(refer('locale')).statement,
            refer('I18n._shouldReload').assign(literal(false)).statement,
            refer('locale').assign(refer('I18n._locale')).statement,
            refer('locale')
                .nullSafeProperty('toString')
                .call(const [])
                .ifNullThen(literal(''))
                .assignFinal('lang')
                .statement,
            refer('locale')
                .nullSafeProperty('languageCode')
                .ifNullThen(literal(''))
                .assignFinal('languageCode')
                .statement,
            for (final l in _languages.keys)
              Code("if ('$l' == lang) {return SynchronousFuture"
                  "<WidgetsLocalizations>(const _I18n_$l());}"),
            for (final c in _parent.keys)
              Code("if ('$c' == languageCode) {return SynchronousFuture"
                  "<WidgetsLocalizations>(const _I18n_${_parent[c]}());}"),
            Code("return SynchronousFuture"
                "<WidgetsLocalizations>(const I18n());"),
          ]);
        }),
        Method((m) {
          m.name = 'isSupported';
          m.returns = refer('bool');
          m.requiredParameters.add(Parameter((p) {
            p.name = 'locale';
            p.type = refer('Locale');
          }));
          m.body = Code(''' 
            for (var i = 0; i < supportedLocales.length && locale != null; i++) {
              final l = supportedLocales[i];
              if (l.languageCode == locale.languageCode) {
                return true;
              }
            }
            return false;
          ''');
        }),
        Method((m) {
          m.name = 'shouldReload';
          m.returns = refer('bool');
          m.lambda = true;
          m.requiredParameters.add(Parameter((p) {
            p.name = 'old';
            p.type = refer('GeneratedLocalizationsDelegate');
          }));
          m.body = refer('I18n._shouldReload').code;
        }),
      ]);
    });
  }

  // Simple message.
  static List _buildSimpleMessage(SimpleMessage message) {
    if (message.parameters.isEmpty) {
      return _buildSimpleMessageWithoutParameters(message);
    } else {
      return _buildSimpleMessageWithParameters(message);
    }
  }

  // Simple message without parameters.
  static List _buildSimpleMessageWithoutParameters(SimpleMessage message) {
    return [
      Method((m) {
        m.name = camelize(message.key);
        m.returns = refer('String');
        m.type = MethodType.getter;
        m.lambda = true;
        m.body = message.expression.code;
      }),
    ];
  }

  // Simple message with parameters.
  static List _buildSimpleMessageWithParameters(SimpleMessage message) {
    final parameters = <String, MessageParameter>{};

    for (final p in message.parameters) {
      if (!parameters.containsKey(p.name)) {
        parameters[p.name] = p;
      }
    }

    return [
      Method((m) {
        m.name = camelize(message.key);
        m.returns = refer('String');

        for (final parameter in parameters.values) {
          m.requiredParameters.add(Parameter((p) {
            p.name = parameter.name;
            p.type = refer('${parameter.type}');
          }));
        }

        m.lambda = true;
        m.body = message.expression.code;
      }),
    ];
  }

  static List _buildListMessage(ListMessage message) {
    if (message.parameters.isEmpty) {
      return _buildListMessageWithoutParameters(message);
    } else {
      return _buildListMessageWithParameters(message);
    }
  }

  // List message without parameters.
  static List _buildListMessageWithoutParameters(ListMessage message) {
    return [
      Method((m) {
        m.name = camelize(message.key);
        m.returns = refer('List<String>');
        m.type = MethodType.getter;
        m.lambda = true;
        m.body = message.expression.code;
      }),
    ];
  }

  // List message with parameters.
  static List _buildListMessageWithParameters(ListMessage message) {
    final parameters = <String, MessageParameter>{};

    for (final p in message.parameters) {
      if (!parameters.containsKey(p.name)) {
        parameters[p.name] = p;
      }
    }

    return [
      Method((m) {
        m.name = camelize(message.key);
        m.returns = refer('List<String>');

        for (final parameter in parameters.values) {
          m.requiredParameters.add(Parameter((p) {
            p.name = parameter.name;
            p.type = refer('${parameter.type}');
          }));
        }

        m.lambda = true;
        m.body = message.expression.code;
      }),
    ];
  }

  static List _buildPluralMessage(
    List<PluralMessage> messages,
    Language language,
  ) {
    final parameters = <String, MessageParameter>{};

    parameters['quantity'] = MessageParameter('quantity', int);

    for (final message in messages) {
      for (final p in message.parameters) {
        if (!parameters.containsKey(p.name)) {
          parameters[p.name] = p;
        }
      }
    }

    return [
      Method((m) {
        m.name = camelize(messages[0].key);
        m.returns = refer('String');

        for (final parameter in parameters.values) {
          m.requiredParameters.add(Parameter((p) {
            p.name = parameter.name;
            p.type = refer('${parameter.type}');
          }));
        }

        m.lambda = true;
        m.body = refer('Intl.plural').call(
          [refer('quantity')],
          {
            'locale': literal('$language'),
            for (final message in messages)
              pluralName(message.type): message.expression,
          },
        ).code;
      }),
    ];
  }

  static List _buildDateMessage(
    DateMessage message,
    Language language,
  ) {
    final name = camelize(message.key);
    final formatterName = '_${name}Formatter';

    return [
      Field((m) {
        m.name = formatterName;
        m.static = true;
        m.modifier = FieldModifier.final$;
        m.assignment = refer('DateFormat').newInstance(
          [literal(message.value), literal('$language')],
        ).code;
      }),
      Method((m) {
        m.name = name;
        m.returns = refer('String');

        m.requiredParameters.add(Parameter((p) {
          p.name = 'date';
          p.type = refer('DateTime');
        }));

        m.lambda = true;
        m.body = refer('$formatterName.format').call(
          [refer('date')],
        ).code;
      }),
    ];
  }

  static List _buildNumberMessage(
    NumberMessage message,
    Language language,
  ) {
    final name = camelize(message.key);
    final formatterName = '_${name}Formatter';

    return [
      Field((m) {
        m.name = formatterName;
        m.static = true;
        m.modifier = FieldModifier.final$;
        m.assignment = refer('NumberFormat').newInstance(
          [literal(message.value), literal('$language')],
        ).code;
      }),
      Method((m) {
        m.name = name;
        m.returns = refer('String');

        m.requiredParameters.add(Parameter((p) {
          p.name = 'number';
          p.type = refer('num');
        }));

        m.lambda = true;
        m.body = refer('$formatterName.format').call(
          [refer('number')],
        ).code;
      }),
    ];
  }

  static PluralType pluralTypeFromKey(String key) {
    if (key.endsWith('.zero')) return PluralType.zero;
    if (key.endsWith('.one')) return PluralType.one;
    if (key.endsWith('.two')) return PluralType.two;
    if (key.endsWith('.few')) return PluralType.few;
    if (key.endsWith('.many')) return PluralType.many;
    if (key.endsWith('.other')) return PluralType.other;
    return null;
  }

  static String removePluralTypeFromKey(String key) {
    if (key.length > 4 && (key.endsWith('.zero') || key.endsWith('.many'))) {
      return key.substring(0, key.length - 5);
    }

    if (key.length > 3 &&
        (key.endsWith('.one') ||
            key.endsWith('.two') ||
            key.endsWith('.few'))) {
      return key.substring(0, key.length - 4);
    }

    if (key.length > 5 && key.endsWith('.other')) {
      return key.substring(0, key.length - 6);
    }

    return key;
  }

  static String camelize(String key) {
    final parts = key.split(_camelizeRegex);

    return parts.fold<StringBuffer>(
      StringBuffer(),
      (a, b) {
        if (a.length > 0) {
          a.write(b[0].toUpperCase());

          if (b.length > 1) {
            a.write(b.substring(1));
          }
        } else {
          a.write(b);
        }

        return a;
      },
    ).toString();
  }

  Iterable<Language> get languages => _items.keys;

  bool hasLanguage(Language language) {
    return _items.containsKey(language);
  }

  Map<String, dynamic> language(Language language) {
    return _items[language];
  }

  bool removeLanguage(Language language) {
    if (_items.remove(language) != null) {
      _languages.remove(language);
      _delegate = _buildDelegate();
      _constants = _buildConstants();
      return true;
    } else {
      return false;
    }
  }

  bool hasKey(
    Language language,
    String key,
  ) {
    return hasLanguage(language) && _items[language].containsKey(key);
  }

  Iterable<String> keys(Language language) => _items[language]?.keys;

  dynamic value(
    Language language,
    String key,
  ) {
    if (hasLanguage(language)) {
      return _items[language][key];
    } else {
      return null;
    }
  }

  bool removeKey(
    Language language,
    String key,
  ) {
    return hasLanguage(language) && _items[language].remove(key) != null;
  }

  List<Message> messages(Language language) {
    return _messages[language];
  }

  Message message(
    Language language,
    String key,
  ) {
    try {
      return _messages[language]?.firstWhere((m) => m.key == key);
    } catch (e) {
      return null;
    }
  }

  void forEachValue(
    Language language,
    void Function(String key, dynamic value) callback,
  ) {
    _items[language]?.forEach(callback);
  }

  void forEachMessage(
    Language language,
    void Function(Message message) callback,
  ) {
    _messages[language]?.forEach(callback);
  }
}

class ParseError extends Error {
  final String message;
  final Language language;

  ParseError(this.message, this.language);

  ParseError.invalidValue(String key, dynamic value, this.language)
      : message = "Invalid value '$value' for key '$key'";

  ParseError.invalidType(String key, Type type, this.language)
      : message = "Invalid value type '$type' for key '$key'";

  ParseError.invalidKey(String key, this.language)
      : message = "Message key '$key' has an invalid format";

  @override
  String toString() {
    return '[$language]: $message';
  }
}
