import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ============================================================================
// PAGE 1: WELCOME SCREEN (Exact Pixel Match to Mockup Image)
// ============================================================================

class WelcomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const WelcomeScreen({super.key, required this.onNavigate});

  void _showLoginBottomSheet(BuildContext context) {
    final phoneCtrl = TextEditingController(text: '03009876543');
    final passCtrl = TextEditingController(text: 'Password123');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sign In to Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkInk)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            buildCustomInputField(
              label: 'Mobile Number',
              controller: phoneCtrl,
              hintText: '03XXXXXXXXX',
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
            const SizedBox(height: 12),
            buildPillButton('Sign In', () {
              Navigator.pop(ctx);
              onNavigate(3);
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Forest Green Header Container (#006B4F)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      decoration: const BoxDecoration(
                        color: kForestGreen,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white30, width: 1.5),
                            ),
                            child: const Icon(Icons.handyman_outlined, color: Colors.white, size: 26),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Hunar Near Me',
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'ہنر آپ کے قریب',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Find trusted skilled professionals near you',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 14),

                          // Combined Capsule Badge [ 📍 Local Experts | ✓ Trusted Reviews ]
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: const [
                                Icon(Icons.location_on_outlined, color: Colors.white, size: 14),
                                Text('Local Experts', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                Text('|', style: TextStyle(color: Colors.white38, fontSize: 12)),
                                Icon(Icons.check_circle_outline, color: Colors.white, size: 14),
                                Text('Trusted Reviews', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Team Illustration Graphic Container (Matches Screenshots Exactly)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/workers_team.png',
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kCardGreenTint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.engineering, size: 40, color: kForestGreen),
                                Icon(Icons.plumbing, size: 40, color: kForestGreen),
                                Icon(Icons.restaurant, size: 40, color: kForestGreen),
                                Icon(Icons.format_paint, size: 40, color: kForestGreen),
                                Icon(Icons.build, size: 40, color: kForestGreen),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Let's Get Started Section
                    const SizedBox(height: 6),
                    const Text('Let\'s Get Started', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkInk)),
                    const SizedBox(height: 4),
                    const Text('Choose how you want to join', style: TextStyle(color: kMutedText, fontSize: 13)),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          buildPillButton(
                            'Register as Customer',
                            () => onNavigate(1),
                            leadingIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 12),
                          buildPillButton(
                            'Register as Worker',
                            () => onNavigate(2),
                            leadingIcon: Icons.engineering_outlined,
                            outline: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(fontSize: 13, color: kMutedText)),
                        GestureDetector(
                          onTap: () => _showLoginBottomSheet(context),
                          child: const Text('Login', style: TextStyle(color: kForestGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('English  |  اردو', style: TextStyle(fontSize: 12, color: kMutedText)),
                    const SizedBox(height: 12),
                    const Text('By continuing, you agree to our Terms & Privacy Policy', style: TextStyle(fontSize: 10, color: kMutedText)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
