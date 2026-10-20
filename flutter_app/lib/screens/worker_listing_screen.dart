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
            decoration: BoxDecoration(
                color: kCardGreenTint, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: kForestGreen, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Workers near ${app.getLocationName(app.selectedArea)}, ${app.getLocationName(app.selectedCity)}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kDarkInk),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final w in app.workers.where(
            (worker) => worker.approvalStatus == 'APPROVED',
          ))
            Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: kBorderColor)),
              child: InkWell(
                onTap: () => onNavigate(6),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: kCardGreenTint,
                        child: const Icon(Icons.engineering,
                            color: kForestGreen, size: 30),
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: kDarkInk,
                                    ),
                                  ),
                                ),
                                if (w.verifiedBadge)
                                  const Icon(Icons.verified,
                                      color: kForestGreen, size: 16),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${app.getLocationName(w.areaId)}, ${app.getLocationName(w.cityId)}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: kMutedText, fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 15),
                                    Flexible(
                                      child: Text(
                                        ' ${w.ratingAverage} (${w.ratingCount} reviews)',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text('📍 ${w.distanceKm} km',
                                    style: const TextStyle(
                                        color: kForestGreen, fontSize: 12)),
                              ],
                            ),
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
