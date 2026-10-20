import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 7: WORKER DETAIL PROFILE & BOOKING REQUEST
// ============================================================================

class WorkerDetailScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const WorkerDetailScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final worker = app.workers.first;

    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => onNavigate(5)),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: kBorderColor)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: kCardGreenTint,
                    child: const Icon(Icons.engineering,
                        color: kForestGreen, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(worker.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kDarkInk)),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: const [
                      Icon(Icons.verified, color: kForestGreen, size: 16),
                      Text('Verified Skilled Worker',
                          style: TextStyle(
                              color: kForestGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '⭐ ${worker.ratingAverage} / 5  •  ${worker.ratingCount} reviews  •  ${worker.completedJobs} jobs done',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('About Worker',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: kDarkInk)),
          const SizedBox(height: 4),
          Text(worker.bio,
              style: const TextStyle(color: kMutedText, fontSize: 13)),
          const SizedBox(height: 24),
          buildPillButton(
              'Request Service & Propose Price', () => onNavigate(7)),
        ],
      ),
    );
  }
}
