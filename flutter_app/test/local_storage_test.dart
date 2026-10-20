import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunar_near_me/providers/app_state.dart';
import 'package:hunar_near_me/screens/customer_register_screen.dart';
import 'package:hunar_near_me/screens/login_screen.dart';
import 'package:hunar_near_me/screens/worker_register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('registration and app choices persist locally across app state reloads',
      () async {
    final app = HunarAppData();
    await app.initialize();
    await app.registerCustomer(
      name: 'Ayesha Khan',
      phone: '3001234567',
    );
    await app.registerWorker(
      name: 'Ali Raza',
      phone: '3017654321',
      profession: 'Electrician',
    );
    await app.updateLocation(city: 'karachi', area: 'gulshan_karachi');
    await app.selectService('s2');

    final restored = HunarAppData();
    await restored.initialize();

    expect(restored.currentUserName, 'Ali Raza');
    expect(restored.currentRole, 'WORKER');
    expect(restored.localAccounts['03001234567']?['name'], 'Ayesha Khan');
    expect(restored.workers.first.name, 'Ali Raza');
    expect(restored.workers.first.approvalStatus, 'PENDING');
    expect(restored.selectedCity, 'karachi');
    expect(restored.selectedArea, 'gulshan_karachi');
    expect(restored.selectedServiceId, 's2');
  });

  test('worker approval persists as a local-only admin action', () async {
    final app = HunarAppData();
    await app.initialize();
    await app.registerWorker(
      name: 'Local Worker',
      phone: '3021234567',
      profession: 'Plumber',
    );
    final workerId = app.workers.first.id;

    await app.approveWorker(workerId);

    final restored = HunarAppData();
    await restored.initialize();
    expect(restored.workers.first.approvalStatus, 'APPROVED');
    expect(restored.workers.first.paymentStatus, 'VERIFIED');
  });

  testWidgets('customer registration saves the profile locally', (
    tester,
  ) async {
    final app = HunarAppData();
    int? destination;
    await tester.pumpWidget(
      AppScope(
        data: app,
        child: MaterialApp(
          home: CustomerRegisterScreen(
            onNavigate: (value) => destination = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), '3001234567');
    await tester.enterText(find.byType(TextField).at(2), 'secure-pass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(app.localAccounts['03001234567']?['name'], 'Sara Ali');
    expect(destination, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('worker registration and sign-in use local profiles', (
    tester,
  ) async {
    final app = HunarAppData();
    int? destination;
    await tester.pumpWidget(
      AppScope(
        data: app,
        child: MaterialApp(
          home: WorkerRegisterScreen(
            onNavigate: (value) => destination = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Bilal Ahmed');
    await tester.enterText(find.byType(TextField).at(1), '3011234567');
    await tester.enterText(find.byType(TextField).at(2), 'secure-pass');
    final professionDropdown = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(professionDropdown);
    await tester.pumpAndSettle();
    await tester.tap(professionDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Electrician (بجلی کا کام)').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(app.workers.first.name, 'Bilal Ahmed');
    expect(app.workers.first.approvalStatus, 'PENDING');
    expect(app.localAccounts['03011234567']?['role'], 'WORKER');
    expect(destination, 3);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      AppScope(
        data: app,
        child: MaterialApp(
          home: LoginScreen(onNavigate: (value) => destination = value),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).at(0), '3011234567');
    await tester.enterText(find.byType(TextField).at(1), 'any-local-password');
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(app.currentUserName, 'Bilal Ahmed');
    expect(app.currentRole, 'WORKER');
    expect(destination, 3);
    expect(tester.takeException(), isNull);
  });
}
