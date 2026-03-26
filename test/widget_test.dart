import 'package:flutter_test/flutter_test.dart';
import 'package:rebirth_city/main.dart';

void main() {
  testWidgets('renders ReBirth City home tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const ReBirthCityApp());

    expect(find.text('RE:BIRTH CITY'), findsNWidgets(2));
    expect(find.text('街の運営'), findsWidgets);
    expect(find.text('終活アクション'), findsOneWidget);
    expect(find.text('市民の未来を明るく設計するための基盤画面です。'), findsOneWidget);
  });
}
