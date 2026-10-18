import 'package:flutter_test/flutter_test.dart';
import 'package:hunarnearme/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HunarApp());

    // Verify that the app title 'Hunar Near Me' is rendered
    expect(find.textContaining('Hunar Near Me'), findsWidgets);
  });
}
