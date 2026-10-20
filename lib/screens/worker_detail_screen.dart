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
            elevation: 1,
            shadowColor: kDarkInk.withValues(alpha: 0.06),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: kBorderColor)),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kCardGreenTint, Colors.white],
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.engineering_outlined, color: kForestGreen, size: 42),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        worker.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kBorderColor),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: kForestGreen, size: 15),
                            SizedBox(width: 5),
                            Text(
                              'Verified Skilled Worker',
                              style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined, color: kMutedText, size: 15),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${app.getLocationName(worker.areaId)}, ${app.getLocationName(worker.cityId)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: kMutedText, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                const SizedBox(width: 3),
                                Text(
                                  worker.ratingAverage.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkInk),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text('${worker.ratingCount} reviews', style: const TextStyle(color: kMutedText, fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: kBorderColor),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${worker.completedJobs}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkInk),
                            ),
                            const SizedBox(height: 3),
                            const Text('jobs done', style: TextStyle(color: kMutedText, fontSize: 10)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: kBorderColor),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${worker.experienceYears} yrs',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkInk),
                            ),
                            const SizedBox(height: 3),
                            const Text('experience', style: TextStyle(color: kMutedText, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Services offered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkInk)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: app.services
                .where((service) => worker.serviceIds.contains(service.id))
                .map(
                  (service) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: kCardGreenTint,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kBorderColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(service.icon, color: service.iconColor, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          service.name,
                          style: const TextStyle(color: kDarkInk, fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kBorderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, color: kForestGreen, size: 19),
                    const SizedBox(width: 7),
                    const Text('About worker', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kDarkInk)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(worker.bio, style: const TextStyle(color: kMutedText, fontSize: 13, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          buildPillButton('Request Service & Propose Price', () => onNavigate(7)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
