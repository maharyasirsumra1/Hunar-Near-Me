import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';

// ============================================================================
// CENTRAL APP STATE MANAGEMENT
// ============================================================================

class HunarAppData extends ChangeNotifier {
  String appName = 'Hunar Near Me';
  String appNameUrdu = 'ہنر آپ کے قریب';
  int workerFeePkr = 500;
  String easypaisaNumber = '0300-1234567 (Hunar Admin)';
  String jazzcashNumber = '0312-7654321 (Hunar Admin)';
  String lang = 'en';

  String currentRole = 'CUSTOMER';
  String currentUserName = 'Muhammad Yasir';
  String currentUserPhone = '0300-9876543';

  String selectedProvince = 'punjab';
  String selectedCity = 'lahore';
  String selectedArea = 'johar_town';
  String? selectedServiceId;
  double searchRadiusKm = 15;
  String sortBy = 'best';

  List<ServiceCategory> services = [
    ServiceCategory(id: 's1', name: 'Electrician', nameUrdu: 'بجلی کا کام', imageAsset: 'assets/images/services/electrician.png', icon: Icons.lightbulb_outlined, iconColor: Colors.amber.shade700),
    ServiceCategory(id: 's2', name: 'Plumber', nameUrdu: 'پلمبر', imageAsset: 'assets/images/services/plumber.png', icon: Icons.water_drop_outlined, iconColor: Colors.blue.shade600),
    ServiceCategory(id: 's3', name: 'AC Repair', nameUrdu: 'اے سی ریپئر', imageAsset: 'assets/images/services/ac-repair.png', icon: Icons.ac_unit_outlined, iconColor: Colors.cyan.shade600),
    ServiceCategory(id: 's5', name: 'Mechanic', nameUrdu: 'میکینک', imageAsset: 'assets/images/services/mechanic.png', icon: Icons.build_outlined, iconColor: Colors.blueGrey),
    ServiceCategory(id: 's4', name: 'Painter', nameUrdu: 'پینٹر', imageAsset: 'assets/images/services/painter.png', icon: Icons.format_paint_outlined, iconColor: Colors.teal),
    ServiceCategory(id: 's6', name: 'Carpenter', nameUrdu: 'کارپینٹر', imageAsset: 'assets/images/services/carpenter.png', icon: Icons.handyman_outlined, iconColor: Colors.brown),
    ServiceCategory(id: 's10', name: 'Cleaning', nameUrdu: 'صفائی کا کام', imageAsset: 'assets/images/services/cleaning.png', icon: Icons.cleaning_services_outlined, iconColor: Colors.orange.shade800),
    ServiceCategory(id: 's7', name: 'Tutor', nameUrdu: 'ٹیوٹر', imageAsset: 'assets/images/services/tutor.png', icon: Icons.school_outlined, iconColor: Colors.indigo),
    ServiceCategory(id: 's8', name: 'Tailor', nameUrdu: 'درزی', imageAsset: 'assets/images/services/tailor.png', icon: Icons.content_cut_outlined, iconColor: Colors.pink.shade700),
    ServiceCategory(id: 's9', name: 'Cook', nameUrdu: 'کک / باورچی', imageAsset: 'assets/images/services/cook.png', icon: Icons.restaurant_outlined, iconColor: Colors.deepOrange),
    ServiceCategory(id: 's11', name: 'Gardener', nameUrdu: 'مالی / باغبانی', imageAsset: 'assets/images/services/gardener.png', icon: Icons.eco_outlined, iconColor: Colors.green.shade700),
    ServiceCategory(id: 's12', name: 'More', nameUrdu: 'مزید', imageAsset: 'assets/images/services/more.png', icon: Icons.more_horiz, iconColor: kForestGreen),
  ];

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
      bio: 'Expert plumber for water tank cleaning, pipe leakage, motor fitting, and sanitary fixtures.',
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
  ];

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
  ];

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

  void refreshUI() {
    notifyListeners();
  }
}

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
