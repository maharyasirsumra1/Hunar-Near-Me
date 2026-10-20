import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 6: WORKER SEARCH & LISTING
// ============================================================================

class WorkerListingScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const WorkerListingScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => onNavigate(4)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kCardGreenTint, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: kForestGreen, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Workers near ${app.getLocationName(app.selectedArea)}, ${app.getLocationName(app.selectedCity)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kDarkInk),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Trusted professionals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkInk),
                  ),
                ),
                Text(
                  '${app.workers.length} available',
                  style: const TextStyle(fontSize: 12, color: kMutedText),
                ),
              ],
            ),
          ),

          for (final w in app.workers)
            Card(
              color: Colors.white,
              elevation: 1,
              shadowColor: kDarkInk.withValues(alpha: 0.06),
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: kBorderColor)),
              child: InkWell(
                onTap: () => onNavigate(6),
                borderRadius: BorderRadius.circular(18),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: kCardGreenTint,
                        child: const Icon(Icons.engineering_outlined, color: kForestGreen, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    w.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDarkInk),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (w.verifiedBadge) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: kForestGreen, size: 17),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: kMutedText, size: 14),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    '${app.getLocationName(w.areaId)}, ${app.getLocationName(w.cityId)}',
                                    style: const TextStyle(color: kMutedText, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: app.services
                                  .where((service) => w.serviceIds.contains(service.id))
                                  .take(2)
                                  .map(
                                    (service) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: kLightGreenBackground,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        service.name,
                                        style: const TextStyle(color: kForestGreen, fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 17),
                                const SizedBox(width: 3),
                                Text(
                                  w.ratingAverage.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: kDarkInk),
                                ),
                                Text(' (${w.ratingCount} reviews)', style: const TextStyle(color: kMutedText, fontSize: 11)),
                                const Spacer(),
                                const Icon(Icons.near_me_outlined, color: kForestGreen, size: 14),
                                const SizedBox(width: 3),
                                Text('${w.distanceKm} km', style: const TextStyle(color: kForestGreen, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: Icon(Icons.chevron_right, color: kForestGreen),
                      ),
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
