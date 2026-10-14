import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:controle_lotacao_academia/main.dart';
import 'package:controle_lotacao_academia/widgets/pessoa_item.dart';

Future<void> abrirApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  GoogleFonts.config.allowRuntimeFetching = false;
  await tester.pumpWidget(const MeuApp());
  await tester.pumpAndSettle();
}

Future<void> cadastrar(
  WidgetTester tester,
  String nome,
  String matricula,
) async {
  await tester.ensureVisible(find.byKey(const Key('nome')));
  await tester.enterText(find.byKey(const Key('nome')), nome);
  await tester.enterText(find.byKey(const Key('matricula')), matricula);
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('CADASTRAR ENTRADA'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('CADASTRAR ENTRADA'));
  await tester.pumpAndSettle();
}

Future<void> deslizarPrimeiro(WidgetTester tester) async {
  final item = find.byType(PessoaItem).first;
  await tester.ensureVisible(item);
  await tester.drag(item, const Offset(-400, 0));
  await tester.pumpAndSettle();
}

Future<void> confirmar(WidgetTester tester) async {
  await tester.tap(find.text('CONFIRMAR'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('impede cadastro vazio e campos com apenas espaços', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, '   ', '   ');
    expect(find.text('0 / 20'), findsOneWidget);
    expect(find.text('Preencha o nome e a matrícula.'), findsOneWidget);
    await cadastrar(tester, 'Maria', '');
    expect(find.byType(PessoaItem), findsNothing);
    await cadastrar(tester, '', '123');
    expect(find.byType(PessoaItem), findsNothing);
  });

  testWidgets('cadastra pessoa, remove espaços e mostra data e situação', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, '  Maria Silva  ', '  123  ');
    expect(find.text('1 / 20'), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('Matrícula: 123'), findsOneWidget);
    expect(find.text('No ambiente'), findsOneWidget);
    expect(find.text('Pessoa cadastrada com sucesso!'), findsOneWidget);
    expect(
      find.textContaining(RegExp(r'Entrada: \d{2}/\d{2}/\d{4} \d{2}:\d{2}')),
      findsOneWidget,
    );
    final campo = tester.widget<TextField>(find.byKey(const Key('nome')));
    expect(campo.controller!.text, isEmpty);
  });

  testWidgets('bloqueia matrícula duplicada ignorando caixa e espaços', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', 'ABC123');
    await cadastrar(tester, 'João', ' abc123 ');
    expect(find.text('1 / 20'), findsOneWidget);
    expect(find.text('Registros (1)'), findsOneWidget);
    expect(
      find.text('Já existe uma pessoa no ambiente com essa matrícula.'),
      findsOneWidget,
    );
  });

  testWidgets('avisa em 16 pessoas e bloqueia a vigésima primeira entrada', (
    tester,
  ) async {
    await abrirApp(tester);
    for (var i = 1; i <= 20; i++) {
      await cadastrar(tester, 'Aluno $i', 'ID$i');
      if (i == 16) {
        expect(find.text('Atenção: academia quase cheia'), findsOneWidget);
      }
    }
    expect(find.text('20 / 20'), findsOneWidget);
    expect(find.text('Academia lotada'), findsOneWidget);
    await cadastrar(tester, 'Aluno extra', 'ID21');
    expect(find.text('20 / 20'), findsOneWidget);
    expect(find.text('Registros (20)'), findsOneWidget);
    expect(
      find.text('Não é possível registrar a entrada. Academia lotada!'),
      findsOneWidget,
    );
  });

  testWidgets('Slidable oferece duas ações e saída exige confirmação', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', '123');
    await deslizarPrimeiro(tester);
    expect(find.text('SAÍDA'), findsOneWidget);
    expect(find.text('EXCLUIR'), findsOneWidget);
    await tester.tap(find.text('SAÍDA'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('CANCELAR'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 20'), findsOneWidget);
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('SAÍDA'));
    await tester.pumpAndSettle();
    await confirmar(tester);
    expect(find.text('0 / 20'), findsOneWidget);
    expect(find.text('Saiu'), findsOneWidget);
    expect(find.textContaining('Saída: '), findsOneWidget);
    expect(find.text('Saída registrada com sucesso!'), findsOneWidget);

    // Também verifica a proteção na função do pai, além do botão desabilitado.
    tester.widget<PessoaItem>(find.byType(PessoaItem)).onSaida();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('0 / 20'), findsOneWidget);
    expect(
      find.text('A saída dessa pessoa já foi registrada.'),
      findsOneWidget,
    );
    await deslizarPrimeiro(tester);
    final acao = tester.widget<SlidableAction>(
      find.byWidgetPredicate(
        (widget) => widget is SlidableAction && widget.label == 'SAÍDA',
      ),
    );
    expect(acao.onPressed, isNull);
  });

  testWidgets('permite nova entrada da mesma matrícula após saída', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', '123');
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('SAÍDA'));
    await tester.pumpAndSettle();
    await confirmar(tester);
    await cadastrar(tester, 'Maria', '123');
    expect(find.text('1 / 20'), findsOneWidget);
    expect(find.text('Registros (2)'), findsOneWidget);
    expect(find.text('No ambiente'), findsOneWidget);
    expect(find.text('Saiu'), findsOneWidget);
  });

  testWidgets('cancelar exclusão preserva registro; confirmar libera a vaga', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, 'João', '456');
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('EXCLUIR'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CANCELAR'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 20'), findsOneWidget);
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('EXCLUIR'));
    await tester.pumpAndSettle();
    await confirmar(tester);
    expect(find.text('0 / 20'), findsOneWidget);
    expect(find.byType(PessoaItem), findsNothing);
    expect(find.text('Registro excluído com sucesso!'), findsOneWidget);
  });

  testWidgets('excluir registro de quem saiu não diminui os demais presentes', (
    tester,
  ) async {
    await abrirApp(tester);
    await cadastrar(tester, 'João', '456');
    await cadastrar(tester, 'Maria', '123');
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('SAÍDA'));
    await tester.pumpAndSettle();
    await confirmar(tester);
    expect(find.text('1 / 20'), findsOneWidget);
    await deslizarPrimeiro(tester);
    await tester.tap(find.text('EXCLUIR'));
    await tester.pumpAndSettle();
    await confirmar(tester);
    expect(find.text('1 / 20'), findsOneWidget);
    expect(find.text('Registros (1)'), findsOneWidget);
    expect(find.text('João'), findsOneWidget);
  });

  testWidgets('formulário continua acessível em tela pequena com teclado', (
    tester,
  ) async {
    await abrirApp(tester);
    tester.view.physicalSize = const Size(360, 640);
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await cadastrar(tester, 'Aluno em tela pequena', '789');
    expect(find.text('1 / 20'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
