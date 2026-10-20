import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hunar_near_me/main.dart';
import 'package:hunar_near_me/providers/app_state.dart';
import 'package:hunar_near_me/screens/admin_panel_screen.dart';
import 'package:hunar_near_me/screens/choose_service_type_screen.dart';
import 'package:hunar_near_me/screens/customer_register_screen.dart';
import 'package:hunar_near_me/screens/location_selection_screen.dart';
import 'package:hunar_near_me/screens/login_screen.dart';
import 'package:hunar_near_me/screens/welcome_screen.dart';
import 'package:hunar_near_me/screens/worker_detail_screen.dart';
import 'package:hunar_near_me/screens/worker_listing_screen.dart';
import 'package:hunar_near_me/screens/worker_register_screen.dart';
import 'package:hunar_near_me/theme/app_theme.dart';

void main() {
  const viewports = [
    Size(320, 568),
    Size(360, 640),
    Size(393, 852),
    Size(430, 932),
    Size(568, 320),
  ];

  testWidgets('all screens fit common mobile viewports and text scales', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    final screens = <(String, Widget)>[
      ('Welcome', WelcomeScreen(onNavigate: (_) {})),
      ('Customer registration', CustomerRegisterScreen(onNavigate: (_) {})),
      ('Worker registration', WorkerRegisterScreen(onNavigate: (_) {})),
      ('Login', LoginScreen(onNavigate: (_) {})),
      ('Service selection', ChooseServiceTypeScreen(onNavigate: (_) {})),
      ('Location selection', LocationSelectionScreen(onNavigate: (_) {})),
      ('Worker listing', WorkerListingScreen(onNavigate: (_) {})),
      ('Worker detail', WorkerDetailScreen(onNavigate: (_) {})),
      ('Admin panel', WebAdminPanelScreen(onNavigate: (_) {})),
    ];

    for (final viewport in viewports) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = viewport;

      for (final (screenName, screen) in screens) {
        for (final textScale in [1.0, 1.5, 2.0]) {
          tester.platformDispatcher.textScaleFactorTestValue = textScale;
          await tester.pumpWidget(
            AppScope(
              data: HunarAppData(),
              child: MaterialApp(home: screen),
            ),
          );
          await tester.pumpAndSettle();

          final exception = tester.takeException();
          expect(
            exception,
            isNull,
            reason:
                '$screenName overflowed at ${viewport.width}x${viewport.height}, '
                'text scale $textScale',
          );
        }
      }
    }
  });

  testWidgets('mobile app shell hides the desktop demo navigation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 640);

    await tester.pumpWidget(const HunarApp());
    await tester.pumpAndSettle();

    expect(find.text('1. Welcome'), findsNothing);
    expect(find.text('Let\'s Get Started'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop navigation labels have clear text and backgrounds', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 768);

    await tester.pumpWidget(const HunarApp());
    await tester.pumpAndSettle();

    final selectedLabel = tester.widget<Text>(find.text('1. Welcome'));
    final selectedButton = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('1. Welcome'),
            matching: find.byType(Container),
          )
          .first,
    );
    final unselectedLabel = tester.widget<Text>(
      find.text('2. Customer Signup'),
    );
    final unselectedButton = tester.widget<Container>(
      find
          .ancestor(
            of: find.text('2. Customer Signup'),
            matching: find.byType(Container),
          )
          .first,
    );

    expect(selectedLabel.style?.color, kDarkInk);
    expect((selectedButton.decoration! as BoxDecoration).color, kCardGreenTint);
    expect(unselectedLabel.style?.color, Colors.white);
    expect(
      (unselectedButton.decoration! as BoxDecoration).color,
      kNavigationChipBackground,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration screens fill the same available screen size', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);

    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(
          home: CustomerRegisterScreen(onNavigate: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final contentSize = tester.getSize(
      find.byKey(const ValueKey('customer-registration-content')),
    );
    expect(contentSize.height, greaterThanOrEqualTo(700));
    final customerButtonSize = tester.getSize(
      find.widgetWithText(ElevatedButton, 'Continue'),
    );

    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(home: WorkerRegisterScreen(onNavigate: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    final workerContentSize = tester.getSize(
      find.byKey(const ValueKey('worker-registration-content')),
    );
    final workerButtonSize = tester.getSize(
      find.widgetWithText(ElevatedButton, 'Continue'),
    );
    expect(workerContentSize, contentSize);
    expect(workerButtonSize.width, customerButtonSize.width);
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration screens share consistent text styling', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);

    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(
          home: CustomerRegisterScreen(onNavigate: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final customerHeading = tester.widget<Text>(
      find.text('Register as Customer'),
    );
    final customerSubtitle = tester.widget<Text>(
      find.text('Find trusted skilled professionals near you'),
    );
    final customerFooter = tester.widget<Text>(
      find.text('By continuing, you agree to our Terms & Privacy Policy'),
    );

    await tester.pumpWidget(
      AppScope(
        data: HunarAppData(),
        child: MaterialApp(home: WorkerRegisterScreen(onNavigate: (_) {})),
      ),
    );
    await tester.pumpAndSettle();

    final workerHeading = tester.widget<Text>(find.text('Register as Worker'));
    final workerSubtitle = tester.widget<Text>(
      find.text('Showcase your skills and get more work'),
    );
    final workerFooter = tester.widget<Text>(
      find.text('By continuing, you agree to our Terms & Privacy Policy'),
    );

    expect(customerHeading.style, workerHeading.style);
    expect(customerSubtitle.style, workerSubtitle.style);
    expect(customerFooter.style, workerFooter.style);
    expect(tester.takeException(), isNull);
  });
}
