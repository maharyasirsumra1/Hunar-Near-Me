import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/service_vector_icons.dart';

// ============================================================================
// PAGE 4: CHOOSE SERVICE TYPE (Exact Match to Reference Screenshot)
// ============================================================================

class ChooseServiceTypeScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const ChooseServiceTypeScreen({super.key, required this.onNavigate});

  @override
  State<ChooseServiceTypeScreen> createState() => _ChooseServiceTypeScreenState();
}

class _ChooseServiceTypeScreenState extends State<ChooseServiceTypeScreen> {
  String? selectedId = 's1';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => widget.onNavigate(1)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose Service Type', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkInk)),
              const SizedBox(height: 4),
              const Text('Select the service you need', style: TextStyle(color: kMutedText, fontSize: 13)),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  itemCount: app.services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (ctx, i) {
                    final s = app.services[i];
                    final isSelected = selectedId == s.id;
                    return InkWell(
                      onTap: () {
                        setState(() => selectedId = s.id);
                        app.selectedServiceId = s.id;
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? kCardGreenTint : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? kForestGreen : kBorderColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ServiceVectorIcon(
                              serviceId: s.id,
                              size: 56,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: kDarkInk),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              buildPillButton('Continue', () => widget.onNavigate(4)),
              Center(
                child: TextButton(
                  onPressed: () => widget.onNavigate(4),
                  child: const Text('Skip for now', style: TextStyle(color: kMutedText, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
