import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 2: REGISTER AS CUSTOMER (Matching Mockup Screenshot 3)
// ============================================================================

class CustomerRegisterScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const CustomerRegisterScreen({super.key, required this.onNavigate});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final nameCtrl = TextEditingController(text: 'Muhammad Yasir');
  final phoneCtrl = TextEditingController(text: '3009876543');
  final passCtrl = TextEditingController(text: 'Password123');

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
                      Text('Register as Customer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kForestGreen)),
                      SizedBox(height: 4),
                      Text('Find trusted skilled professionals near you', style: TextStyle(color: kMutedText, fontSize: 12)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: kCardGreenTint,
                  child: const Icon(Icons.person, color: kForestGreen, size: 36),
                ),
              ],
            ),
            const SizedBox(height: 20),

            buildStepProgress(['Basic Info', 'Location', 'Done'], 0),
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

            const SizedBox(height: 16),
            buildPillButton('Continue', () => widget.onNavigate(3)),
            const SizedBox(height: 16),
            const Center(
              child: Text('By continuing, you agree to our Terms & Privacy Policy', style: TextStyle(fontSize: 11, color: kMutedText)),
            ),
          ],
        ),
      ),
    );
  }
}
