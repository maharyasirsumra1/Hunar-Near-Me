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
  State<ChooseServiceTypeScreen> createState() =>
      _ChooseServiceTypeScreenState();
}

class _ChooseServiceTypeScreenState extends State<ChooseServiceTypeScreen> {
  String? selectedId = 's1';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 44,
        leadingWidth: 40,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          icon: const Icon(Icons.arrow_back, color: kForestGreen, size: 18),
          onPressed: () => widget.onNavigate(1),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handyman_outlined, color: kForestGreen, size: 16),
            const SizedBox(width: 4),
            Text(
              app.appName,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: kDarkInk,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => app.toggleLanguage(),
            child: Text(
              app.lang == 'en' ? 'English ⌄' : 'اردو ⌄',
              style: const TextStyle(
                color: kForestGreen,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Service Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kForestGreen,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Select the service you need',
                style: TextStyle(color: kMutedText, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                '${app.services.length} services available',
                style: const TextStyle(
                  color: kForestGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  itemCount: app.services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 7,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (ctx, i) {
                    final s = app.services[i];
                    final isSelected = selectedId == s.id;
                    return Card(
                      color: Colors.white,
                      elevation: isSelected ? 2 : 0,
                      shadowColor: kForestGreen.withValues(alpha: 0.12),
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? kForestGreen
                              : const Color(0xFFE8EFEB),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          setState(() => selectedId = s.id);
                          app.selectedServiceId = s.id;
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              right: 5,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? kForestGreen
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? kForestGreen
                                        : const Color(0xFFE8EFEB),
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 11,
                                      )
                                    : null,
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ServiceVectorIcon(
                                    serviceId: s.id,
                                    size: 38,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    s.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: isSelected
                                          ? kForestGreen
                                          : kDarkInk,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 7),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => widget.onNavigate(4),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kForestGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
