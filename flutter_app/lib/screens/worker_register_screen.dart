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
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? selectedProfession;

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
      backgroundColor: const Color(0xFFF8FBF9),
      appBar: buildAppHeader(context, onBack: () => widget.onNavigate(0)),
      body: RegistrationPageLayout(
        contentKey: const ValueKey('worker-registration-content'),
        formContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const RegistrationHeroHeader(
              title: 'Register as Worker',
              subtitle: 'Showcase your skills and get more work',
              imageAlignment: Alignment(-0.7, 0.2),
              badgeIcons: [Icons.build, Icons.settings, Icons.work],
            ),
            const SizedBox(height: 8),
            buildStepProgress(
              ['Basic Info', 'Skills', 'Location', 'Documents', 'Done'],
              0,
            ),
            const SizedBox(height: 12),
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
              footnote: 'Password must be at least 6 characters',
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
              hint: const Text('Choose your profession'),
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
              onChanged: (val) => setState(() => selectedProfession = val),
            ),
          ],
        ),
        footerContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            buildPillButton('Continue', () => widget.onNavigate(3)),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: TextStyle(fontSize: 11, color: kMutedText),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
