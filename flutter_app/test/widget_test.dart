import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunar_near_me/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const HunarApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('Hunar Near Me'), findsWidgets);
  });
}
