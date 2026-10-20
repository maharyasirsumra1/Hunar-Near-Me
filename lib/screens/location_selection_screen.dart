import 'package:flutter/material.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 5: LOCATION SELECTION SCREEN
// ============================================================================

class LocationSelectionScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const LocationSelectionScreen({super.key, required this.onNavigate});

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => widget.onNavigate(3)),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 360 ? 16.0 : 20.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kForestGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Select your city and area in Pakistan',
                        style: TextStyle(color: kMutedText, fontSize: 13),
                      ),
                      const SizedBox(height: 20),

                      buildStepProgress(['Basic Info', 'Location', 'Done'], 1),
                      const SizedBox(height: 24),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: app.selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Select City',
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: kMutedText,
                          ),
                        ),
                        items: app.locations
                            .where((l) => l.kind == 'city')
                            .map(
                              (l) => DropdownMenuItem(
                                value: l.id,
                                child: Text(l.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => app.selectedCity = val);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: app.selectedArea,
                        decoration: const InputDecoration(
                          labelText: 'Select Area / Housing Society',
                          prefixIcon: Icon(Icons.pin_drop, color: kMutedText),
                        ),
                        items: app.locations
                            .where(
                              (l) =>
                                  l.kind == 'area' &&
                                  l.parentId == app.selectedCity,
                            )
                            .map(
                              (l) => DropdownMenuItem(
                                value: l.id,
                                child: Text(l.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => app.selectedArea = val);
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'GPS coordinates detected: Johar Town, Lahore',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: kForestGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.my_location,
                          color: kForestGreen,
                        ),
                        label: const Text(
                          'Use My Current GPS Location',
                          style: TextStyle(
                            color: kForestGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      buildPillButton('Continue', () => widget.onNavigate(5)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
