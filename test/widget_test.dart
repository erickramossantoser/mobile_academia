import 'package:flutter_test/flutter_test.dart';

import 'package:controle_lotacao_academia/main.dart';

void main() {
  testWidgets('controla a entrada e a saída de pessoas', (tester) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('Pode entrar'), findsOneWidget);

    await tester.tap(find.text('ENTROU'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('SAIU'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('não ultrapassa a capacidade máxima', (tester) async {
    await tester.pumpWidget(const MeuApp());

    for (int i = 0; i < 20; i++) {
      await tester.tap(find.text('ENTROU'));
      await tester.pump();
    }

    expect(find.text('20'), findsOneWidget);
    expect(find.text('Academia lotada'), findsOneWidget);

    await tester.tap(find.text('ENTROU'));
    await tester.pump();
    expect(find.text('20'), findsOneWidget);
  });
}
