import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunarnearme/main.dart';
import 'package:hunarnearme/providers/app_state.dart';
import 'package:hunarnearme/screens/customer_register_screen.dart';
import 'package:hunarnearme/theme/app_theme.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HunarApp());

    // Verify that the app title 'Hunar Near Me' is rendered
    expect(find.textContaining('Hunar Near Me'), findsWidgets);
  });

  testWidgets('Password field can be shown and hidden', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController(text: 'secret123');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildCustomInputField(
            label: 'Password',
            controller: controller,
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
          ),
        ),
      ),
    );

    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isFalse,
    );

    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
  });

  testWidgets('Customer registration shows errors before continuing', (
    WidgetTester tester,
  ) async {
    int? navigatedTo;
    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(
          home: CustomerRegisterScreen(
            onNavigate: (index) => navigatedTo = index,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your full name'), findsWidgets);
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsWidgets);
    expect(navigatedTo, isNull);
  });

  testWidgets('Valid customer details continue to the next step', (
    WidgetTester tester,
  ) async {
    int? navigatedTo;
    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(
          home: CustomerRegisterScreen(
            onNavigate: (index) => navigatedTo = index,
          ),
        ),
      ),
    );

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ayesha Khan');
    await tester.enterText(fields.at(1), '3001234567');
    await tester.enterText(fields.at(2), 'secret123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(navigatedTo, 3);
  });
}
