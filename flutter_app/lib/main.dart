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
  final HunarAppData? appData;

  const HunarApp({super.key, this.appData});

  @override
  State<HunarApp> createState() => _HunarAppState();
}

class _HunarAppState extends State<HunarApp> {
  late final HunarAppData appData = widget.appData ?? HunarAppData();
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = appData.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunar Near Me - ہنر آپ کے قریب',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kForestGreen,
          primary: kForestGreen,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: kLightGreenBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kDarkInk,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kForestGreen, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not load locally saved app data.'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => setState(
                          () => _initialization = appData.initialize(),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return AppScope(
            data: appData,
            child: const AppShellContainer(),
          );
        },
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
          onNavigate: (index) => setState(() => activeTab = index)),
      WorkerRegisterScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
      ChooseServiceTypeScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
      LocationSelectionScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
      WorkerListingScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
      WorkerDetailScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
      WebAdminPanelScreen(
          onNavigate: (index) => setState(() => activeTab = index)),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (MediaQuery.sizeOf(context).width >= 600)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      _buildDemoNavChip('1. Welcome', 0),
                      _buildDemoNavChip('2. Customer Signup', 1),
                      _buildDemoNavChip('3. Worker Signup', 2),
                      _buildDemoNavChip('4. Choose Service', 3),
                      _buildDemoNavChip('5. Location', 4),
                      _buildDemoNavChip('6. Worker Search', 5),
                      _buildDemoNavChip('7. Worker Profile', 6),
                      _buildDemoNavChip('8. Web Admin Panel', 7,
                          isSpecial: true),
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

  Widget _buildDemoNavChip(String label, int index, {bool isSpecial = false}) {
    final bool isSelected = activeTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? (isSpecial ? Colors.amber : kDarkInk)
                : Colors.white,
          ),
        ),
        selected: isSelected,
        selectedColor: isSpecial ? kForestGreen : Colors.white,
        backgroundColor: Colors.white24,
        onSelected: (selected) {
          if (selected) setState(() => activeTab = index);
        },
      ),
    );
  }
}
