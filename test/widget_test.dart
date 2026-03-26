import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rebirth_city/main.dart';

void main() {
  testWidgets('renders ReBirth City mobile home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ReBirthCityApp(),
      ),
    );

    expect(find.text('RE:BIRTH CITY'), findsOneWidget);
    expect(find.text('街の運営'), findsAtLeastNWidgets(1));
    expect(find.text('未来'), findsOneWidget);
    expect(find.text('終活'), findsOneWidget);
    expect(find.text('観光'), findsOneWidget);
    expect(find.text('自治体モックデータ'), findsOneWidget);
    expect(find.text('鎌倉市'), findsAtLeastNWidgets(1));
    expect(find.text('アクション'), findsOneWidget);
    expect(find.text('未来幸福度'), findsOneWidget);
    expect(find.text('健康投資ウォーク'), findsNothing);
  });
}
