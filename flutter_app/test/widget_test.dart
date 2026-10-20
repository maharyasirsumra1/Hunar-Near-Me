import 'package:flutter_test/flutter_test.dart';
import 'package:hunar_near_me/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HunarApp());
    expect(find.textContaining('Hunar Near Me'), findsWidgets);
  });
}
