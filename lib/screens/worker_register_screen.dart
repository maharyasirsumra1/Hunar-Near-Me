import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ============================================================================
// PAGE 3: REGISTER AS WORKER (Matching Mockup Screenshot 4)
// ============================================================================

class WorkerRegisterScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const WorkerRegisterScreen({super.key, required this.onNavigate});

  @override
  State<WorkerRegisterScreen> createState() => _WorkerRegisterScreenState();
}

class _WorkerRegisterScreenState extends State<WorkerRegisterScreen> {
  final nameCtrl = TextEditingController(text: 'Muhammad Tariq');
  final phoneCtrl = TextEditingController(text: '3001234567');
  final passCtrl = TextEditingController(text: 'Password123');
  String selectedProfession = 'Electrician';

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => widget.onNavigate(0)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Register as Worker',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kForestGreen,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Showcase your skills and get more work',
                        style: TextStyle(color: kMutedText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: kCardGreenTint,
                  child: const Icon(
                    Icons.engineering,
                    color: kForestGreen,
                    size: 36,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            buildStepProgress([
              'Basic Info',
              'Skills',
              'Location',
              'Documents',
              'Done',
            ], 0),
            const SizedBox(height: 24),

            buildCustomInputField(
              label: 'Full Name',
              controller: nameCtrl,
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
            ),
            buildCustomInputField(
              label: 'Mobile Number',
              controller: phoneCtrl,
              hintText: 'Enter your mobile number',
              prefixIcon: Icons.phone_outlined,
              isPhone: true,
            ),
            buildCustomInputField(
              label: 'Password',
              controller: passCtrl,
              hintText: 'Create a password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              footnote: 'Password must be at least 8 characters',
            ),

            const Text(
              'Select Your Main Profession',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: kDarkInk,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: selectedProfession,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.work_outline,
                  color: kMutedText,
                  size: 20,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Electrician',
                  child: Text(
                    'Electrician (بجلی کا کام)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Plumber',
                  child: Text(
                    'Plumber (پلمبر)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'AC Repair',
                  child: Text(
                    'AC Repair (اے سی ریپئر)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Mechanic',
                  child: Text(
                    'Mechanic (میکینک)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownMenuItem(
                  value: 'Painter',
                  child: Text(
                    'Painter (پینٹر)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => selectedProfession = val);
              },
            ),

            const SizedBox(height: 24),
            buildPillButton('Continue', () => widget.onNavigate(3)),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: TextStyle(fontSize: 11, color: kMutedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
