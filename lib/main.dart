import 'package:flutter/material.dart';

// ============================================================================
// HUNAR NEAR ME (ہنر آپ کے قریب) - Flutter Web & Mobile Application
// Based on Project Proposal 2026 for Pakistan Skilled Worker Marketplace
// Colors: Forest Green (#006B4F) and Crisp White (#FFFFFF)
// ============================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HunarApp());
}

// ----------------------------------------------------------------------------
// Color Constants
// ----------------------------------------------------------------------------
const Color kForestGreen = Color(0xFF006B4F);
const Color kLightGreenBackground = Color(0xFFF3FAF6);
const Color kCardGreenTint = Color(0xFFE2F4E8);
const Color kDarkInk = Color(0xFF123D30);
const Color kMutedText = Color(0xFF677C74);
const Color kBorderColor = Color(0xFFDFEAE4);

// ----------------------------------------------------------------------------
// Data Models
// ----------------------------------------------------------------------------
class ServiceCategory {
  final String id;
  final String name;
  final String nameUrdu;
  final IconData icon;
  bool active;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.nameUrdu,
    required this.icon,
    this.active = true,
  });
}

class LocationItem {
  final String id;
  final String name;
  final String kind; // 'province', 'city', 'area'
  final String? parentId;

  LocationItem({
    required this.id,
    required this.name,
    required this.kind,
    this.parentId,
  });
}

class WorkerProfile {
  final String id;
  final String name;
  final String phone;
  final List<String> serviceIds;
  final String provinceId;
  final String cityId;
  final String areaId;
  final double distanceKm;
  final double ratingAverage;
  final int ratingCount;
  final int completedJobs;
  final int experienceYears;
  final String bio;
  final bool verifiedBadge;
  String approvalStatus; // 'PENDING', 'APPROVED', 'REJECTED'
  String? paymentMethod;
  String? transactionRef;
  String? paymentStatus; // 'PENDING', 'VERIFIED', 'REJECTED'

  WorkerProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.serviceIds,
    required this.provinceId,
    required this.cityId,
    required this.areaId,
    required this.distanceKm,
    required this.ratingAverage,
    required this.ratingCount,
    required this.completedJobs,
    required this.experienceYears,
    required this.bio,
    this.verifiedBadge = true,
    this.approvalStatus = 'APPROVED',
    this.paymentMethod,
    this.transactionRef,
    this.paymentStatus = 'VERIFIED',
  });
}

class JobBooking {
  final String id;
  final String customerName;
  final String workerId;
  final String serviceName;
  final String description;
  final int proposedPricePkr;
  int? quotedPricePkr;
  final String address;
  String status; // 'PENDING', 'QUOTED', 'ACCEPTED', 'COMPLETED'
  final DateTime createdAt;
  int? ratingGiven;
  String? reviewComment;

  JobBooking({
    required this.id,
    required this.customerName,
    required this.workerId,
    required this.serviceName,
    required this.description,
    required this.proposedPricePkr,
    this.quotedPricePkr,
    required this.address,
    required this.status,
    required this.createdAt,
    this.ratingGiven,
    this.reviewComment,
  });
}

// ----------------------------------------------------------------------------
// Global Central State Management (HunarAppData)
// ----------------------------------------------------------------------------
class HunarAppData extends ChangeNotifier {
  // App Config Settings (Managed by Admin)
  String appName = 'Hunar Near Me';
  String appNameUrdu = 'ہنر آپ کے قریب';
  int workerFeePkr = 500;
  String easypaisaNumber = '0300-1234567 (Hunar Admin)';
  String jazzcashNumber = '0312-7654321 (Hunar Admin)';
  String lang = 'en'; // 'en' or 'ur'

  // User State
  String currentRole = 'CUSTOMER'; // 'GUEST', 'CUSTOMER', 'WORKER', 'ADMIN'
  String currentUserName = 'Muhammad Yasir';
  String currentUserPhone = '0300-9876543';

  // Filters
  String selectedProvince = 'punjab';
  String selectedCity = 'lahore';
  String selectedArea = 'johar_town';
  String? selectedServiceId;
  double searchRadiusKm = 15;
  String sortBy = 'best'; // 'best', 'rating', 'reviews', 'nearest'

  // Services Catalog
  List<ServiceCategory> services = [
    ServiceCategory(id: 's1', name: 'Electrician', nameUrdu: 'بجلی کا کام', icon: Icons.lightbulb_outlined),
    ServiceCategory(id: 's2', name: 'Plumber', nameUrdu: 'پلمبر', icon: Icons.plumbing_outlined),
    ServiceCategory(id: 's3', name: 'AC Repair', nameUrdu: 'اے سی ریپئر', icon: Icons.ac_unit_outlined),
    ServiceCategory(id: 's4', name: 'Painter', nameUrdu: 'پینٹر', icon: Icons.format_paint_outlined),
    ServiceCategory(id: 's5', name: 'Mechanic', nameUrdu: 'میکینک', icon: Icons.build_outlined),
    ServiceCategory(id: 's6', name: 'Carpenter', nameUrdu: 'کارپینٹر', icon: Icons.handyman_outlined),
    ServiceCategory(id: 's7', name: 'Tutor', nameUrdu: 'ٹیوٹر', icon: Icons.school_outlined),
    ServiceCategory(id: 's8', name: 'Tailor', nameUrdu: 'درزی', icon: Icons.content_cut_outlined),
    ServiceCategory(id: 's9', name: 'Cook / Chef', nameUrdu: 'کک / باورچی', icon: Icons.restaurant_outlined),
    ServiceCategory(id: 's10', name: 'Cleaning', nameUrdu: 'صفائی کا کام', icon: Icons.cleaning_services_outlined),
  ];

  // Location Hierarchy
  List<LocationItem> locations = [
    LocationItem(id: 'punjab', name: 'Punjab', kind: 'province'),
    LocationItem(id: 'sindh', name: 'Sindh', kind: 'province'),
    LocationItem(id: 'kpk', name: 'Khyber Pakhtunkhwa', kind: 'province'),
    LocationItem(id: 'ict', name: 'Islamabad Capital Territory', kind: 'province'),

    LocationItem(id: 'lahore', name: 'Lahore', kind: 'city', parentId: 'punjab'),
    LocationItem(id: 'rawalpindi', name: 'Rawalpindi', kind: 'city', parentId: 'punjab'),
    LocationItem(id: 'karachi', name: 'Karachi', kind: 'city', parentId: 'sindh'),
    LocationItem(id: 'islamabad', name: 'Islamabad', kind: 'city', parentId: 'ict'),
    LocationItem(id: 'peshawar', name: 'Peshawar', kind: 'city', parentId: 'kpk'),

    LocationItem(id: 'johar_town', name: 'Johar Town', kind: 'area', parentId: 'lahore'),
    LocationItem(id: 'dha_lahore', name: 'DHA Phase 5', kind: 'area', parentId: 'lahore'),
    LocationItem(id: 'gulshan_karachi', name: 'Gulshan-e-Iqbal', kind: 'area', parentId: 'karachi'),
    LocationItem(id: 'f7_islamabad', name: 'Sector F-7', kind: 'area', parentId: 'islamabad'),
  ];

  // Workers Data
  List<WorkerProfile> workers = [
    WorkerProfile(
      id: 'w1',
      name: 'Muhammad Tariq',
      phone: '0300-1234567',
      serviceIds: ['s1', 's3'],
      provinceId: 'punjab',
      cityId: 'lahore',
      areaId: 'johar_town',
      distanceKm: 1.2,
      ratingAverage: 4.9,
      ratingCount: 38,
      completedJobs: 142,
      experienceYears: 8,
      bio: 'Professional electrician specializing in home wiring, short circuit repair, and AC installation.',
      verifiedBadge: true,
      approvalStatus: 'APPROVED',
      paymentMethod: 'EASYPAISA',
      transactionRef: 'EP-9821345',
      paymentStatus: 'VERIFIED',
    ),
    WorkerProfile(
      id: 'w2',
      name: 'Zahid Hussain',
      phone: '0301-8765432',
      serviceIds: ['s3'],
      provinceId: 'punjab',
      cityId: 'lahore',
      areaId: 'dha_lahore',
      distanceKm: 3.5,
      ratingAverage: 4.8,
      ratingCount: 24,
      completedJobs: 89,
      experienceYears: 6,
      bio: 'AC Gas refilling, inverter AC installation, outdoor unit servicing & repairs.',
      verifiedBadge: true,
      approvalStatus: 'APPROVED',
      paymentMethod: 'JAZZCASH',
      transactionRef: 'JC-4421901',
      paymentStatus: 'VERIFIED',
    ),
    WorkerProfile(
      id: 'w3',
      name: 'Rashid Ali',
      phone: '0333-5551234',
      serviceIds: ['s2'],
      provinceId: 'sindh',
      cityId: 'karachi',
      areaId: 'gulshan_karachi',
      distanceKm: 2.1,
      ratingAverage: 4.7,
      ratingCount: 19,
      completedJobs: 65,
      experienceYears: 5,
      bio: 'Expert plumber for water tank cleaning, pipe leakage, motor fitting, and bathroom sanitary fixtures.',
      verifiedBadge: true,
      approvalStatus: 'APPROVED',
      paymentMethod: 'EASYPAISA',
      transactionRef: 'EP-1100293',
      paymentStatus: 'VERIFIED',
    ),
    WorkerProfile(
      id: 'w4',
      name: 'Usman Farooq',
      phone: '0345-9988776',
      serviceIds: ['s7'],
      provinceId: 'ict',
      cityId: 'islamabad',
      areaId: 'f7_islamabad',
      distanceKm: 4.0,
      ratingAverage: 5.0,
      ratingCount: 12,
      completedJobs: 30,
      experienceYears: 4,
      bio: 'Home tutor for Matric, FSc, and O/A Levels (Mathematics & Physics specialist).',
      verifiedBadge: true,
      approvalStatus: 'APPROVED',
      paymentMethod: 'JAZZCASH',
      transactionRef: 'JC-7733210',
      paymentStatus: 'VERIFIED',
    ),
    WorkerProfile(
      id: 'w5',
      name: 'Bilal Ahmad (Pending Application)',
      phone: '0321-4433221',
      serviceIds: ['s4', 's6'],
      provinceId: 'punjab',
      cityId: 'lahore',
      areaId: 'johar_town',
      distanceKm: 0.8,
      ratingAverage: 0.0,
      ratingCount: 0,
      completedJobs: 0,
      experienceYears: 3,
      bio: 'Wall painter and woodwork polisher.',
      verifiedBadge: false,
      approvalStatus: 'PENDING',
      paymentMethod: 'EASYPAISA',
      transactionRef: 'EP-8877665',
      paymentStatus: 'PENDING',
    ),
  ];

  // Job Bookings Data
  List<JobBooking> bookings = [
    JobBooking(
      id: 'b101',
      customerName: 'Muhammad Yasir',
      workerId: 'w1',
      serviceName: 'Electrician (Switchboard Repair)',
      description: 'Main distribution box breaker tripping and two room switchboards need replacement.',
      proposedPricePkr: 1500,
      quotedPricePkr: 1800,
      address: 'House 42, Block R1, Johar Town, Lahore',
      status: 'ACCEPTED',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    JobBooking(
      id: 'b102',
      customerName: 'Muhammad Yasir',
      workerId: 'w2',
      serviceName: 'AC Repair & Gas Refill',
      description: '1.5 Ton Inverter AC not cooling properly.',
      proposedPricePkr: 3000,
      quotedPricePkr: 3500,
      address: 'House 42, Block R1, Johar Town, Lahore',
      status: 'COMPLETED',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ratingGiven: 5,
      reviewComment: 'Very professional worker. Arrived on time and solved cooling problem quickly.',
    ),
  ];

  // Helper Methods
  void toggleLanguage() {
    lang = (lang == 'en') ? 'ur' : 'en';
    notifyListeners();
  }

  void switchRole(String role) {
    currentRole = role;
    notifyListeners();
  }

  String getLocationName(String? id) {
    if (id == null) return '';
    final found = locations.where((element) => element.id == id).toList();
    return found.isNotEmpty ? found.first.name : id;
  }

  void addJobBooking(JobBooking booking) {
    bookings.insert(0, booking);
    notifyListeners();
  }

  void approveWorker(String workerId) {
    final idx = workers.indexWhere((w) => w.id == workerId);
    if (idx != -1) {
      workers[idx].approvalStatus = 'APPROVED';
      workers[idx].paymentStatus = 'VERIFIED';
      notifyListeners();
    }
  }

  void rejectWorker(String workerId) {
    final idx = workers.indexWhere((w) => w.id == workerId);
    if (idx != -1) {
      workers[idx].approvalStatus = 'REJECTED';
      workers[idx].paymentStatus = 'REJECTED';
      notifyListeners();
    }
  }

  void addServiceCategory(String name, String nameUrdu, IconData icon) {
    final newId = 's${services.length + 1}';
    services.add(ServiceCategory(id: newId, name: name, nameUrdu: nameUrdu, icon: icon));
    notifyListeners();
  }

  void updateFeeSettings(int fee, String epNum, String jcNum) {
    workerFeePkr = fee;
    easypaisaNumber = epNum;
    jazzcashNumber = jcNum;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}

// InheritedWidget wrapper for scoping app data
class AppScope extends InheritedNotifier<HunarAppData> {
  const AppScope({
    super.key,
    required HunarAppData data,
    required super.child,
  }) : super(notifier: data);

  static HunarAppData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
  }
}

// ----------------------------------------------------------------------------
// MAIN APP WIDGET
// ----------------------------------------------------------------------------
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
        theme: ThemeData(
          useMaterial3: true,
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
            centerTitle: false,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kForestGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        home: const AppShellContainer(),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// APP SHELL CONTAINER (With Top Web Chrome Control Bar)
// ----------------------------------------------------------------------------
class AppShellContainer extends StatefulWidget {
  const AppShellContainer({super.key});

  @override
  State<AppShellContainer> createState() => _AppShellContainerState();
}

class _AppShellContainerState extends State<AppShellContainer> {
  int activeTab = 0; // 0: Welcome, 1: Auth, 2: Home, 3: Listing, 4: Worker Detail, 5: Worker Fee, 6: Bookings, 7: Admin Panel

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    // Dynamic screens list based on the 8 proposal pages
    final List<Widget> pages = [
      WelcomeScreen(onNavigate: (index) => setState(() => activeTab = index)),
      AuthRegisterScreen(onDone: () => setState(() => activeTab = 2)),
      CustomerHomeScreen(onNavigate: (index) => setState(() => activeTab = index)),
      WorkerListingScreen(onSelectWorker: () => setState(() => activeTab = 4)),
      WorkerDetailScreen(onBookRequested: () => setState(() => activeTab = 6)),
      WorkerRegistrationFeeScreen(onDone: () => setState(() => activeTab = 2)),
      BookingManagementScreen(),
      WebAdminPanelScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP WEB CHROME DEMO CONTROL BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: kDarkInk,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(Icons.handyman, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${app.appName} (${app.appNameUrdu})',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 20),
                    _buildDemoNavChip('1. Welcome', 0),
                    _buildDemoNavChip('2. Register / Login', 1),
                    _buildDemoNavChip('3. Service Catalogue', 2),
                    _buildDemoNavChip('4. Worker Search', 3),
                    _buildDemoNavChip('5. Worker Profile', 4),
                    _buildDemoNavChip('6. Fee Payment', 5),
                    _buildDemoNavChip('7. Bookings', 6),
                    _buildDemoNavChip('8. Web Admin Panel', 7, isSpecial: true),
                    const SizedBox(width: 15),
                    TextButton.icon(
                      onPressed: () => app.toggleLanguage(),
                      icon: const Icon(Icons.language, color: Colors.amber, size: 16),
                      label: Text(
                        app.lang == 'en' ? 'English | اردو' : 'اردو | English',
                        style: const TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // MAIN SCREEN CONTENT
            Expanded(child: pages[activeTab]),
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
            color: isSelected ? (isSpecial ? Colors.amber : kDarkInk) : Colors.white,
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

// ============================================================================
// PAGE 1: WELCOME & ROLE SELECTION SCREEN
// ============================================================================
class WelcomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const WelcomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Hero Green Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kForestGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: kForestGreen.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.handyman_outlined, size: 50, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      app.appName,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      app.appNameUrdu,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pakistan\'s First Verified Local Skilled Worker Platform',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feature Badges
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  Chip(
                    avatar: Icon(Icons.verified_user, color: kForestGreen, size: 18),
                    label: Text('Verified Workers'),
                    backgroundColor: kCardGreenTint,
                  ),
                  Chip(
                    avatar: Icon(Icons.location_on, color: kForestGreen, size: 18),
                    label: Text('GPS & Locality Search'),
                    backgroundColor: kCardGreenTint,
                  ),
                  Chip(
                    avatar: Icon(Icons.payment, color: kForestGreen, size: 18),
                    label: Text('EasyPaisa / JazzCash'),
                    backgroundColor: kCardGreenTint,
                  ),
                ],
              ),

              const SizedBox(height: 36),
              const Text(
                'Choose Your Journey',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select how you want to use Hunar Near Me today',
                style: TextStyle(color: kMutedText, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Journey Action Buttons
              ElevatedButton.icon(
                onPressed: () {
                  app.switchRole('CUSTOMER');
                  onNavigate(2); // Go to Customer Catalogue
                },
                icon: const Icon(Icons.search),
                label: const Text('Find & Hire Skilled Workers (Customer)'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  app.switchRole('WORKER');
                  onNavigate(5); // Go to Worker Registration & Fee
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: kForestGreen, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.engineering, color: kForestGreen),
                label: const Text('Register as Skilled Worker', style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  app.switchRole('ADMIN');
                  onNavigate(7); // Go to Web Admin Control Centre
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  side: const BorderSide(color: kDarkInk, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.admin_panel_settings, color: kDarkInk),
                label: const Text('Open Web Admin Control Centre', style: TextStyle(color: kDarkInk, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 30),
              TextButton(
                onPressed: () => onNavigate(1),
                child: const Text('Already have an account? Sign In', style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PAGE 2: AUTHENTICATION & REGISTRATION SCREEN (SIGNUP / LOGIN / OTP)
// ============================================================================
class AuthRegisterScreen extends StatefulWidget {
  final VoidCallback onDone;

  const AuthRegisterScreen({super.key, required this.onDone});

  @override
  State<AuthRegisterScreen> createState() => _AuthRegisterScreenState();
}

class _AuthRegisterScreenState extends State<AuthRegisterScreen> {
  bool isLogin = false;
  bool isWorker = false;
  final TextEditingController nameCtrl = TextEditingController(text: 'Muhammad Yasir');
  final TextEditingController phoneCtrl = TextEditingController(text: '0300-9876543');
  final TextEditingController passCtrl = TextEditingController(text: 'Password123');

  void _submitAuth() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.sms, color: kForestGreen),
            SizedBox(width: 10),
            Text('SMS OTP Verification'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the 6-digit code sent to ${phoneCtrl.text}:'),
            const SizedBox(height: 14),
            const TextField(
              decoration: InputDecoration(
                hintText: '1 2 3 4 5 6',
                prefixIcon: Icon(Icons.lock_clock),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            const Text('(Development Test OTP: 123456)', style: TextStyle(color: kMutedText, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDone();
            },
            child: const Text('Verify & Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Register'),
                    selected: !isLogin,
                    onSelected: (v) => setState(() => isLogin = false),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Sign In'),
                    selected: isLogin,
                    onSelected: (v) => setState(() => isLogin = true),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkInk),
              ),
              const SizedBox(height: 6),
              Text(
                isLogin ? 'Enter your registered Pakistani mobile number' : 'Sign up to connect with nearby customers & workers',
                style: const TextStyle(color: kMutedText, fontSize: 13),
              ),
              const SizedBox(height: 20),

              if (!isLogin) ...[
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Customer'), icon: Icon(Icons.person)),
                    ButtonSegment(value: true, label: Text('Worker'), icon: Icon(Icons.engineering)),
                  ],
                  selected: {isWorker},
                  onSelectionChanged: (Set<bool> selection) {
                    setState(() => isWorker = selection.first);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 14),
              ],

              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Mobile Number (+92)', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitAuth,
                child: Text(isLogin ? 'Sign In' : 'Continue with Verification →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PAGE 3: CUSTOMER SERVICE CATALOGUE & LOCAL DISCOVERY (HOME)
// ============================================================================
class CustomerHomeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const CustomerHomeScreen({super.key, required this.onNavigate});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return ListView(
      padding: const EdgeInsets.all(18.0),
      children: [
        // Welcome Banner
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome, ${app.currentUserName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
                const Text('Find local talent near your area', style: TextStyle(color: kMutedText, fontSize: 13)),
              ],
            ),
            const CircleAvatar(
              backgroundColor: kCardGreenTint,
              child: Icon(Icons.person, color: kForestGreen),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Pakistan Location Selector Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kCardGreenTint,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderColor),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: kForestGreen, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Location (Pakistan)', style: TextStyle(color: kMutedText, fontSize: 11)),
                    Text(
                      '${app.getLocationName(app.selectedArea)}, ${app.getLocationName(app.selectedCity)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkInk),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_location_alt, color: kForestGreen),
                onPressed: () => _showLocationDialog(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar with Voice Simulator
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Search Electrician, Plumber, AC Repair...',
                  prefixIcon: Icon(Icons.search, color: kForestGreen),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: kForestGreen),
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice Assistant: "Searching for nearby Electricians in Johar Town..."')),
                );
                app.selectedServiceId = 's1';
                widget.onNavigate(3);
              },
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Service Categories Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Service Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkInk)),
            Text('${app.services.length} Available', style: const TextStyle(color: kMutedText, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),

        // Service Categories Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: app.services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (ctx, i) {
            final s = app.services[i];
            return InkWell(
              onTap: () {
                app.selectedServiceId = s.id;
                widget.onNavigate(3); // Go to Worker Listing Page
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorderColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: kCardGreenTint,
                      radius: 22,
                      child: Icon(s.icon, color: kForestGreen, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: kDarkInk)),
                    Text(s.nameUrdu, style: const TextStyle(fontSize: 10, color: kForestGreen)),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 24),
        // Search Radius Slider
        Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: kBorderColor)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Search Distance Radius', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkInk)),
                    Text('${app.searchRadiusKm.toInt()} km', style: const TextStyle(color: kForestGreen, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: app.searchRadiusKm,
                  min: 1,
                  max: 50,
                  activeColor: kForestGreen,
                  onChanged: (val) {
                    setState(() => app.searchRadiusKm = val);
                  },
                ),
                const Text('Showing workers within straight-line GPS distance', style: TextStyle(fontSize: 11, color: kMutedText)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLocationDialog(BuildContext context) {
    final app = AppScope.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Location in Pakistan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: app.selectedCity,
              decoration: const InputDecoration(labelText: 'City'),
              items: app.locations.where((l) => l.kind == 'city').map((l) => DropdownMenuItem(value: l.id, child: Text(l.name))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => app.selectedCity = val);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: app.selectedArea,
              decoration: const InputDecoration(labelText: 'Locality / Sector'),
              items: app.locations.where((l) => l.kind == 'area' && l.parentId == app.selectedCity).map((l) => DropdownMenuItem(value: l.id, child: Text(l.name))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => app.selectedArea = val);
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              app.refreshUI();
              Navigator.pop(ctx);
            },
            child: const Text('Save Location'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 4: WORKER SEARCH & LISTING SCREEN
// ============================================================================
class WorkerListingScreen extends StatelessWidget {
  final VoidCallback onSelectWorker;

  const WorkerListingScreen({super.key, required this.onSelectWorker});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    // Filter approved workers
    final filteredWorkers = app.workers.where((w) {
      if (w.approvalStatus != 'APPROVED') return false;
      if (app.selectedServiceId != null && !w.serviceIds.contains(app.selectedServiceId)) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligible Skilled Workers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Filter Summary Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kCardGreenTint, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: kForestGreen, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Showing ${filteredWorkers.length} approved workers near ${app.getLocationName(app.selectedArea)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kDarkInk),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (filteredWorkers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(child: Text('No approved workers found for this criteria. Try selecting another city or service.')),
            )
          else
            for (final w in filteredWorkers)
              Card(
                color: Colors.white,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: kBorderColor)),
                child: InkWell(
                  onTap: onSelectWorker,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: kCardGreenTint,
                          child: const Icon(Icons.engineering, color: kForestGreen, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkInk)),
                                  if (w.verifiedBadge) const Icon(Icons.verified, color: kForestGreen, size: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${app.getLocationName(w.areaId)}, ${app.getLocationName(w.cityId)}', style: const TextStyle(color: kMutedText, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text(' ${w.ratingAverage} (${w.ratingCount} reviews)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  const SizedBox(width: 12),
                                  Text('📍 ${w.distanceKm} km away', style: const TextStyle(color: kForestGreen, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text('📞 ${w.phone} • ${w.completedJobs} completed jobs', style: const TextStyle(fontSize: 11, color: kMutedText)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: kForestGreen),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 5: WORKER DETAIL PROFILE & BOOKING REQUEST SCREEN
// ============================================================================
class WorkerDetailScreen extends StatelessWidget {
  final VoidCallback onBookRequested;

  const WorkerDetailScreen({super.key, required this.onBookRequested});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final worker = app.workers.first; // Muhammad Tariq

    return Scaffold(
      appBar: AppBar(title: Text(worker.name)),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          // Header Card
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: kBorderColor)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: kCardGreenTint,
                    child: Icon(Icons.engineering, color: kForestGreen, size: 42),
                  ),
                  const SizedBox(height: 10),
                  Text(worker.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkInk)),
                  const SizedBox(height: 4),
                  const Chip(
                    avatar: Icon(Icons.verified, color: kForestGreen, size: 16),
                    label: Text('Verified Skilled Worker'),
                    backgroundColor: kCardGreenTint,
                  ),
                  const SizedBox(height: 8),
                  Text('📍 ${app.getLocationName(worker.areaId)}, ${app.getLocationName(worker.cityId)}', style: const TextStyle(color: kMutedText)),
                  const SizedBox(height: 6),
                  Text('⭐ ${worker.ratingAverage} / 5  •  ${worker.ratingCount} reviews  •  ${worker.completedJobs} jobs done', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          const Text('About Worker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkInk)),
          const SizedBox(height: 6),
          Text(worker.bio, style: const TextStyle(color: kMutedText, fontSize: 13)),
          const SizedBox(height: 18),

          // Portfolio Samples
          const Text('Work Samples / Portfolio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkInk)),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildPortfolioCard('Switchboard Wiring'),
                _buildPortfolioCard('Inverter AC Install'),
                _buildPortfolioCard('Breaker Panel Repair'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          ElevatedButton.icon(
            onPressed: () => _showBookingDialog(context, worker, app),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Request Service & Propose Price'),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard(String title) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: kCardGreenTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, color: kForestGreen, size: 28),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kDarkInk), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, WorkerProfile worker, HunarAppData app) {
    final TextEditingController descCtrl = TextEditingController(text: 'Need switchboard repair and wiring check.');
    final TextEditingController priceCtrl = TextEditingController(text: '1500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${worker.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Job Description'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Proposed Budget (PKR)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              app.addJobBooking(JobBooking(
                id: 'b${app.bookings.length + 101}',
                customerName: app.currentUserName,
                workerId: worker.id,
                serviceName: 'Electrician Service',
                description: descCtrl.text,
                proposedPricePkr: int.tryParse(priceCtrl.text) ?? 1500,
                address: '${app.getLocationName(app.selectedArea)}, ${app.getLocationName(app.selectedCity)}',
                status: 'PENDING',
                createdAt: DateTime.now(),
              ));
              Navigator.pop(ctx);
              onBookRequested();
            },
            child: const Text('Send Job Request'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 6: WORKER REGISTRATION & EASYPAISA / JAZZCASH FEE VERIFICATION
// ============================================================================
class WorkerRegistrationFeeScreen extends StatefulWidget {
  final VoidCallback onDone;

  const WorkerRegistrationFeeScreen({super.key, required this.onDone});

  @override
  State<WorkerRegistrationFeeScreen> createState() => _WorkerRegistrationFeeScreenState();
}

class _WorkerRegistrationFeeScreenState extends State<WorkerRegistrationFeeScreen> {
  String selectedMethod = 'EASYPAISA';
  final TextEditingController txRefCtrl = TextEditingController(text: 'EP-99887711');
  bool isReceiptUploaded = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Worker Account Fee Verification', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkInk)),
              const SizedBox(height: 6),
              const Text('Submit your one-time verification fee via EasyPaisa or JazzCash for admin approval.', style: TextStyle(color: kMutedText, fontSize: 13)),
              const SizedBox(height: 20),

              // Fee Amount Display Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: kForestGreen, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('One-Time Registration Fee', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Text('Verification & Listing', style: TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                    Text('Rs. ${app.workerFeePkr}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Method Select
              const Text('Select Payment Account', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkInk)),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'EASYPAISA', label: Text('EasyPaisa'), icon: Icon(Icons.account_balance_wallet)),
                  ButtonSegment(value: 'JAZZCASH', label: Text('JazzCash'), icon: Icon(Icons.payment)),
                ],
                selected: {selectedMethod},
                onSelectionChanged: (Set<String> sel) {
                  setState(() => selectedMethod = sel.first);
                },
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kCardGreenTint, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  selectedMethod == 'EASYPAISA' ? 'EasyPaisa Number: ${app.easypaisaNumber}' : 'JazzCash Number: ${app.jazzcashNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkInk),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: txRefCtrl,
                decoration: const InputDecoration(
                  labelText: 'Transaction Reference / TRX ID',
                  hintText: 'e.g. TRX-12345678',
                  prefixIcon: Icon(Icons.receipt_long),
                ),
              ),
              const SizedBox(height: 14),

              OutlinedButton.icon(
                onPressed: () {
                  setState(() => isReceiptUploaded = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment receipt image uploaded successfully')));
                },
                icon: Icon(isReceiptUploaded ? Icons.check_circle : Icons.upload_file, color: kForestGreen),
                label: Text(isReceiptUploaded ? 'Receipt Screenshot Attached ✓' : 'Upload Payment Receipt Screenshot'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fee verification request submitted! Admin will verify payment.')),
                  );
                  widget.onDone();
                },
                child: const Text('Submit Fee Verification Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PAGE 7: CUSTOMER & WORKER BOOKING MANAGEMENT
// ============================================================================
class BookingManagementScreen extends StatelessWidget {
  const BookingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings & Job Status')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          for (final b in app.bookings)
            Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: kBorderColor)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(b.serviceName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkInk)),
                        Chip(
                          label: Text(b.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                          backgroundColor: b.status == 'COMPLETED' ? kForestGreen : (b.status == 'ACCEPTED' ? Colors.blue : Colors.orange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(b.description, style: const TextStyle(color: kMutedText, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('Proposed Budget: Rs. ${b.proposedPricePkr}  •  Quoted: Rs. ${b.quotedPricePkr ?? "—"}', style: const TextStyle(fontWeight: FontWeight.bold, color: kForestGreen)),
                    Text('📍 Address: ${b.address}', style: const TextStyle(fontSize: 11, color: kMutedText)),
                    const SizedBox(height: 12),

                    if (b.status == 'ACCEPTED')
                      ElevatedButton(
                        onPressed: () {
                          b.status = 'COMPLETED';
                          app.refreshUI();
                        },
                        child: const Text('Mark Job Completed'),
                      ),

                    if (b.status == 'COMPLETED' && b.ratingGiven == null)
                      OutlinedButton.icon(
                        onPressed: () => _showReviewDialog(context, b, app),
                        icon: const Icon(Icons.star, color: Colors.amber),
                        label: const Text('Submit Rating & Review'),
                      ),

                    if (b.ratingGiven != null)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: kCardGreenTint, borderRadius: BorderRadius.circular(8)),
                        child: Text('Your Review: ⭐ ${b.ratingGiven}/5 - "${b.reviewComment}"', style: const TextStyle(fontSize: 12, color: kDarkInk)),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, JobBooking b, HunarAppData app) {
    final TextEditingController commentCtrl = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Customer Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star, color: index < rating ? Colors.amber : Colors.grey),
                  onPressed: () {
                    rating = index + 1;
                    (ctx as Element).markNeedsBuild();
                  },
                );
              }),
            ),
            TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(labelText: 'Feedback / Comments'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              b.ratingGiven = rating;
              b.reviewComment = commentCtrl.text;
              app.refreshUI();
              Navigator.pop(ctx);
            },
            child: const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PAGE 8: WEB ADMINISTRATOR CONTROL CENTRE (ADMIN PANEL)
// ============================================================================
class WebAdminPanelScreen extends StatefulWidget {
  const WebAdminPanelScreen({super.key});

  @override
  State<WebAdminPanelScreen> createState() => _WebAdminPanelScreenState();
}

class _WebAdminPanelScreenState extends State<WebAdminPanelScreen> {
  int adminTab = 0; // 0: Overview, 1: Worker Approvals, 2: Services, 3: Settings

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: kDarkInk),
            SizedBox(width: 8),
            Text('Web Administrator Control Centre'),
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 180,
            color: kDarkInk,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildSidebarTile(Icons.dashboard, 'Overview', 0),
                _buildSidebarTile(Icons.verified_user, 'Worker Fee', 1),
                _buildSidebarTile(Icons.category, 'Services', 2),
                _buildSidebarTile(Icons.settings, 'Fee Settings', 3),
              ],
            ),
          ),

          // Admin Main Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _buildAdminTabContent(app),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTile(IconData icon, String title, int index) {
    final isSelected = adminTab == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.amber : Colors.white70, size: 20),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
      selected: isSelected,
      onTap: () => setState(() => adminTab = index),
    );
  }

  Widget _buildAdminTabContent(HunarAppData app) {
    switch (adminTab) {
      case 0:
        return ListView(
          children: [
            const Text('Platform Overview Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Total Workers', '${app.workers.length}', Icons.engineering),
                const SizedBox(width: 12),
                _buildStatCard('Pending Approvals', '${app.workers.where((w) => w.approvalStatus == 'PENDING').length}', Icons.pending_actions),
                const SizedBox(width: 12),
                _buildStatCard('Bookings Made', '${app.bookings.length}', Icons.calendar_today),
              ],
            ),
          ],
        );

      case 1:
        return ListView(
          children: [
            const Text('Worker Application & Fee Approvals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
            const SizedBox(height: 16),
            for (final w in app.workers)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('${w.name} (${w.phone})'),
                  subtitle: Text('Fee: Rs. ${app.workerFeePkr} via ${w.paymentMethod ?? "EASYPAISA"} | Ref: ${w.transactionRef ?? "N/A"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(w.approvalStatus),
                        backgroundColor: w.approvalStatus == 'APPROVED' ? kForestGreen : Colors.orange,
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      if (w.approvalStatus == 'PENDING') ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: kForestGreen),
                          onPressed: () => app.approveWorker(w.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => app.rejectWorker(w.id),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );

      case 2:
        return ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Manage Service Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
                ElevatedButton.icon(
                  onPressed: () => _showAddServiceDialog(context, app),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final s in app.services)
              Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: kCardGreenTint, child: Icon(s.icon, color: kForestGreen)),
                  title: Text(s.name),
                  subtitle: Text(s.nameUrdu),
                  trailing: Switch(
                    value: s.active,
                    activeTrackColor: kForestGreen,
                    onChanged: (val) {
                      setState(() => s.active = val);
                    },
                  ),
                ),
              ),
          ],
        );

      case 3:
      default:
        final feeCtrl = TextEditingController(text: app.workerFeePkr.toString());
        final epCtrl = TextEditingController(text: app.easypaisaNumber);
        final jcCtrl = TextEditingController(text: app.jazzcashNumber);

        return ListView(
          children: [
            const Text('Admin Payment & Fee Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
            const SizedBox(height: 16),
            TextField(controller: feeCtrl, decoration: const InputDecoration(labelText: 'Worker Registration Fee (PKR)')),
            const SizedBox(height: 12),
            TextField(controller: epCtrl, decoration: const InputDecoration(labelText: 'EasyPaisa Merchant Number')),
            const SizedBox(height: 12),
            TextField(controller: jcCtrl, decoration: const InputDecoration(labelText: 'JazzCash Merchant Number')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                app.updateFeeSettings(int.tryParse(feeCtrl.text) ?? 500, epCtrl.text, jcCtrl.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin fee settings saved successfully')));
              },
              child: const Text('Save Settings'),
            ),
          ],
        );
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorderColor)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: kCardGreenTint, child: Icon(icon, color: kForestGreen)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: kMutedText, fontSize: 11)),
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkInk)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context, HunarAppData app) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController urduCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Service Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Service Name (English)')),
            const SizedBox(height: 12),
            TextField(controller: urduCtrl, decoration: const InputDecoration(labelText: 'Service Name (Urdu)')),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                app.addServiceCategory(nameCtrl.text, urduCtrl.text, Icons.handyman);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }
}
