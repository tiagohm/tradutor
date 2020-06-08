import 'package:flutter_test/flutter_test.dart';

import '../example/lib/i18n.dart';

void main() {
  test('Simple Message', () {
    expect(enUS.simpleMessage, 'Home Page');
    expect(ptBR.simpleMessage, 'Página Inicial');
    expect(ptPT.simpleMessage, 'Página Inicial');
  });

  test('Simple Message With Parameters', () {
    expect(enUS.simpleMessageWithParameters('Tiago'), 'Hello Tiago');
    expect(ptBR.simpleMessageWithParameters('Tiago'), 'Olá Tiago');
    expect(ptPT.simpleMessageWithParameters('Tiago'), 'Olá Tiago');
  });

  test('List Message', () {
    expect(enUS.listMessage, const ['Green', 'Yellow', 'Blue', 'White']);
    expect(ptBR.listMessage, const ['Verde', 'Amarelo', 'Azul', 'Branco']);
    expect(ptPT.listMessage, const ['Verde', 'Amarelo', 'Azul', 'Branco']);
  });

  test('List Message With Parameters', () {
    expect(enUS.listMessageWithParameters(1, 2, 3, 4, 5, 6, 7), const [
      '1 cup white sugar',
      '2 cup butter',
      '3 eggs',
      '4 teaspoons vanilla extract',
      '5 cups all-purpose flour',
      '6 teaspoons baking powder',
      '7 cup milk'
    ]);
    expect(ptBR.listMessageWithParameters(1, 2, 3, 4, 5, 6, 7), const [
      '1 copos de açúcar cristal',
      '2 copo de manteiga',
      '3 ovos',
      '4 colher (chá) de extrato de baunilha',
      '5 copos de farinha de trigo',
      '6 colher (chá) de fermento em pó',
      '7 copo de leite'
    ]);
    expect(ptPT.listMessageWithParameters(1, 2, 3, 4, 5, 6, 7), const [
      '1 copos de açúcar cristal',
      '2 copo de manteiga',
      '3 ovos',
      '4 colher (chá) de extrato de baunilha',
      '5 copos de farinha de trigo',
      '6 colher (chá) de fermento em pó',
      '7 copo de leite'
    ]);
  });

  test('Plural Message', () {
    expect(enUS.pluralMesssage(0), 'Button tapped 0 times');
    expect(enUS.pluralMesssage(1), 'Button tapped 1 time');
    expect(enUS.pluralMesssage(2), 'Button tapped 2 times');
    expect(ptBR.pluralMesssage(0), 'Botão foi clicado 0 vez');
    expect(ptBR.pluralMesssage(1), 'Botão foi clicado 1 vez');
    expect(ptBR.pluralMesssage(2), 'Botão foi clicado 2 vezes');
    expect(ptPT.pluralMesssage(0), 'Botão foi pressionado 0 vezes');
    expect(ptPT.pluralMesssage(1), 'Botão foi pressionado 1 vez');
    expect(ptPT.pluralMesssage(2), 'Botão foi pressionado 2 vezes');
  });

  test('Plural Message With Parameters', () {
    expect(enUS.pluralMesssageWithParameters(0, 'Button', 'tapped'),
        'Button tapped 0 times');
    expect(enUS.pluralMesssageWithParameters(1, 'Button', 'tapped'),
        'Button tapped 1 time');
    expect(enUS.pluralMesssageWithParameters(2, 'Button', 'tapped'),
        'Button tapped 2 times');
    expect(ptBR.pluralMesssageWithParameters(0, 'Botão', 'clicado'),
        'Botão foi clicado 0 vez');
    expect(ptBR.pluralMesssageWithParameters(1, 'Botão', 'clicado'),
        'Botão foi clicado 1 vez');
    expect(ptBR.pluralMesssageWithParameters(2, 'Botão', 'clicado'),
        'Botão foi clicado 2 vezes');
    expect(ptPT.pluralMesssageWithParameters(0, 'Botão', 'pressionado'),
        'Botão foi pressionado 0 vezes');
    expect(ptPT.pluralMesssageWithParameters(1, 'Botão', 'pressionado'),
        'Botão foi pressionado 1 vez');
    expect(ptPT.pluralMesssageWithParameters(2, 'Botão', 'pressionado'),
        'Botão foi pressionado 2 vezes');
  });

  test('Curly Brackets', () {
    expect(enUS.messageWithOneCurlyBracket,
        'This message contains one {curly_bracket}');
    expect(enUS.messageWithTwoCurlyBrackets,
        'This message contains two {{curly_brackets}}');
    expect(ptBR.messageWithOneCurlyBracket, 'Esta mensagem contém uma {chave}');
    expect(ptBR.messageWithTwoCurlyBrackets,
        'Esta mensagem contém duas {{chaves}}');
    expect(ptPT.messageWithOneCurlyBracket, 'Esta mensagem contém uma {chave}');
    expect(ptPT.messageWithTwoCurlyBrackets,
        'Esta mensagem contém duas {{chaves}}');
  });
}
