import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 8: WEB ADMINISTRATOR CONTROL CENTRE
// ============================================================================

class WebAdminPanelScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const WebAdminPanelScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pendingWorkers = app.workers
        .where((worker) => worker.approvalStatus == 'PENDING')
        .toList();

    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => onNavigate(0)),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: kDarkInk, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.amber, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Web Administrator Control Centre',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage platform, fees & worker verification',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Worker Registration Fee Settings'),
              subtitle: Text('Current Fee: Rs. ${app.workerFeePkr} PKR'),
              trailing: const Icon(Icons.edit, color: kForestGreen),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pending Worker Verification Applications',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pendingWorkers.length} Applications awaiting local review',
                  ),
                  const SizedBox(height: 12),
                  if (pendingWorkers.isEmpty)
                    const Text('No pending worker applications.')
                  else
                    for (final worker in pendingWorkers)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${worker.name} · ${app.services.where((service) => worker.serviceIds.contains(service.id)).map((service) => service.name).join(', ')}',
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kForestGreen,
                              ),
                              onPressed: () async {
                                await app.approveWorker(worker.id);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Worker approved on this device.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Approve',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Reject worker',
                              onPressed: () async {
                                await app.rejectWorker(worker.id);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
