import 'package:flutter/material.dart';

import 'providers/app_state.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/choose_service_type_screen.dart';
import 'screens/customer_register_screen.dart';
import 'screens/location_selection_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/worker_detail_screen.dart';
import 'screens/worker_listing_screen.dart';
import 'screens/worker_register_screen.dart';
import 'theme/app_theme.dart';

// ============================================================================
// HUNAR NEAR ME (ہنر آپ کے قریب) - Flutter Web & Mobile Main Entry Point
// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HunarApp());
}

class HunarApp extends StatefulWidget {
  const HunarApp({super.key});

  @override
  State<HunarApp> createState() => _HunarAppState();
}

class _HunarAppState extends State<HunarApp> {
  final HunarAppData appData = HunarAppData();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      data: appData,
      child: MaterialApp(
        title: 'Hunar Near Me - ہنر آپ کے قریب',
        debugShowCheckedModeBanner: false,
        theme: buildHunarTheme(),
        home: const AppShellContainer(),
      ),
    );
  }
}

class AppShellContainer extends StatefulWidget {
  const AppShellContainer({super.key});

  @override
  State<AppShellContainer> createState() => _AppShellContainerState();
}

class _AppShellContainerState extends State<AppShellContainer> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      WelcomeScreen(onNavigate: (index) => setState(() => activeTab = index)),
      CustomerRegisterScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      WorkerRegisterScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      ChooseServiceTypeScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      LocationSelectionScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      WorkerListingScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      WorkerDetailScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
      WebAdminPanelScreen(
        onNavigate: (index) => setState(() => activeTab = index),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (MediaQuery.sizeOf(context).width >= 600)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: kDarkInk,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Icon(Icons.handyman, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Hunar Near Me (ہنر آپ کے قریب)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildDemoNavChip('1. Welcome', 0),
                      _buildDemoNavChip('2. Customer Signup', 1),
                      _buildDemoNavChip('3. Worker Signup', 2),
                      _buildDemoNavChip('4. Choose Service', 3),
                      _buildDemoNavChip('5. Location', 4),
                      _buildDemoNavChip('6. Worker Search', 5),
                      _buildDemoNavChip('7. Worker Profile', 6),
                      _buildDemoNavChip('8. Web Admin Panel', 7),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  color: Colors.white,
                  child: pages[activeTab],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoNavChip(String label, int index) {
    final isSelected = activeTab == index;
    final foregroundColor = isSelected ? kDarkInk : Colors.white;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => setState(() => activeTab = index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? kCardGreenTint : kNavigationChipBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFF5A8273),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    Icon(Icons.check_circle, color: foregroundColor, size: 14),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
