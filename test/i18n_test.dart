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
    expect(enUS.listMessageWithParameters(6, 2, 3, 5, 7, 4, 1), const [
      '1 cup white sugar',
      '2 cup butter',
      '3 eggs',
      '4 teaspoons vanilla extract',
      '5 cups all-purpose flour',
      '6 teaspoons baking powder',
      '7 cup milk'
    ]);
    expect(ptBR.listMessageWithParameters(6, 2, 3, 5, 7, 4, 1), const [
      '1 copos de açúcar cristal',
      '2 copo de manteiga',
      '3 ovos',
      '4 colher (chá) de extrato de baunilha',
      '5 copos de farinha de trigo',
      '6 colher (chá) de fermento em pó',
      '7 copo de leite'
    ]);
    expect(ptPT.listMessageWithParameters(6, 2, 3, 5, 7, 4, 1), const [
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
    expect(enUS.pluralMesssageWithParameters(0, 'tapped', 'Button'),
        'Button tapped 0 times');
    expect(enUS.pluralMesssageWithParameters(1, 'tapped', 'Button'),
        'Button tapped 1 time');
    expect(enUS.pluralMesssageWithParameters(2, 'tapped', 'Button'),
        'Button tapped 2 times');
    expect(ptBR.pluralMesssageWithParameters(0, 'clicado', 'Botão'),
        'Botão foi clicado 0 vez');
    expect(ptBR.pluralMesssageWithParameters(1, 'clicado', 'Botão'),
        'Botão foi clicado 1 vez');
    expect(ptBR.pluralMesssageWithParameters(2, 'clicado', 'Botão'),
        'Botão foi clicado 2 vezes');
    expect(ptPT.pluralMesssageWithParameters(0, 'pressionado', 'Botão'),
        'Botão foi pressionado 0 vezes');
    expect(ptPT.pluralMesssageWithParameters(1, 'pressionado', 'Botão'),
        'Botão foi pressionado 1 vez');
    expect(ptPT.pluralMesssageWithParameters(2, 'pressionado', 'Botão'),
        'Botão foi pressionado 2 vezes');
  });

  test('Escape Message', () {
    expect(enUS.escapeMessage('b', 'd', 'e'), '{a} b \\{c} \\d {e} {{f}} \$');
  });

  test('Date Message', () {
    final date = DateTime(2019, 1, 1, 12, 0, 6);
    expect(enUS.dateMessage(date), '01 01, 2019 12:00:06 PM');
    // expect(ptBR.dateMessage(date), 'BRL 12,35');
    // expect(ptPT.dateMessage(date), 'USD 12,35');
  });

  test('Number Message', () {
    expect(enUS.numberMessage(12.345), '12.35');
    expect(enUS.numberMessage(12.301), '12.3');
    expect(ptBR.numberMessage(12.345), '12,35');
    expect(ptBR.numberMessage(12.301), '12,3');
    expect(ptPT.numberMessage(12.345), '12,35');
    expect(ptPT.numberMessage(12.301), '12,3');
  });

  test('Money Message', () {
    expect(enUS.moneyMessage(12.345), '\$12.35');
    expect(ptBR.moneyMessage(12.345), 'R\$ 12,35');
    expect(ptPT.moneyMessage(12.345), '12,35 €');
  });

  test('Percent Message', () {
    expect(enUS.percentMessage(0.123), '12.3%');
    expect(ptBR.percentMessage(0.123), '12,3%');
    expect(ptPT.percentMessage(0.123), '12,3%');
  });

  test('Map Message', () {
    expect(enUS.constellations('AND', 'Alpheratz'),
        'Andromeda (AND) - Brightest star: Alpheratz');
    expect(enUS.constellations('ANT', 'α Antliae'),
        'Antlia (ANT) - Brightest star: α Antliae');
    expect(enUS.constellations('APS', 'α Apodis'),
        'Apus (APS) - Brightest star: α Apodis');
    expect(ptBR.constellations('AND', 'Alpheratz'),
        'Andrômeda (AND) - Estrela mais brilhante: Alpheratz');
    expect(ptBR.constellations('ANT', 'α Antliae'),
        'Máquina Pneumática (ANT) - Estrela mais brilhante: α Antliae');
    expect(ptBR.constellations('APS', 'α Apodis'),
        'Ave-do-paraíso (APS) - Estrela mais brilhante: α Apodis');
    expect(ptPT.constellations('AND', 'Alpheratz'),
        'Andrômeda (AND) - Estrela mais brilhante: Alpheratz');
    expect(ptPT.constellations('ANT', 'α Antliae'),
        'Máquina Pneumática (ANT) - Estrela mais brilhante: α Antliae');
    expect(ptPT.constellations('APS', 'α Apodis'),
        'Ave-do-paraíso (APS) - Estrela mais brilhante: α Apodis');
  });
}
