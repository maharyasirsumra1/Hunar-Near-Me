import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ============================================================================
// LOGIN SCREEN / MODAL (Matching UI System)
// ============================================================================

class LoginScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const LoginScreen({super.key, required this.onNavigate});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController(text: '3009876543');
  final passCtrl = TextEditingController(text: 'Password123');

  void _doLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged in successfully! Welcome back.')),
    );
    widget.onNavigate(3); // Go to Choose Service Catalogue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppHeader(context, onBack: () => widget.onNavigate(0)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: kCardGreenTint,
                child: const Icon(Icons.lock_outline, color: kForestGreen, size: 36),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkInk),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Log in as Customer or Worker with your registered mobile number',
                style: TextStyle(color: kMutedText, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),

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
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset link sent to your registered mobile number.')),
                  );
                },
                child: const Text('Forgot Password?', style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),

            const SizedBox(height: 16),
            buildPillButton('Sign In', _doLogin, leadingIcon: Icons.login),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? ', style: TextStyle(fontSize: 13, color: kMutedText)),
                GestureDetector(
                  onTap: () => widget.onNavigate(1),
                  child: const Text('Register Now', style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
