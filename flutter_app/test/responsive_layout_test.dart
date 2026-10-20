import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('customer registration content fills the available screen', (
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
    expect(tester.takeException(), isNull);
  });
}
