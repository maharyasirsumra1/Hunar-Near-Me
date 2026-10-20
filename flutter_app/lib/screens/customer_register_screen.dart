import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class CustomerRegisterScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const CustomerRegisterScreen({super.key, required this.onNavigate});

  @override
  State<CustomerRegisterScreen> createState() => _CustomerRegisterScreenState();
}

class _CustomerRegisterScreenState extends State<CustomerRegisterScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF9),
      appBar: AppBar(
        toolbarHeight: 56,
        leadingWidth: 44,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 38, height: 40),
          icon: const Icon(Icons.arrow_back, color: kForestGreen, size: 17),
          onPressed: () => widget.onNavigate(0),
        ),
        title: Row(
          children: [
            const Icon(Icons.handyman_outlined, color: kForestGreen, size: 18),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                app.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: kDarkInk,
                ),
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
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 360 ? 12.0 : 16.0;
            final contentHeight =
                constraints.maxHeight > 24 ? constraints.maxHeight - 24 : 0.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    minHeight: contentHeight,
                  ),
                  child: Column(
                    key: const ValueKey('customer-registration-content'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 76),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Register as Customer',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: kForestGreen,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Find trusted skilled\nprofessionals near you',
                                        style: TextStyle(
                                          color: kMutedText,
                                          fontSize: 12,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  height: 72,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        right: 10,
                                        bottom: 0,
                                        width: 72,
                                        height: 68,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          child: Image.asset(
                                            'assets/images/workers_team.png',
                                            fit: BoxFit.cover,
                                            alignment:
                                                const Alignment(-0.85, 0.2),
                                          ),
                                        ),
                                      ),
                                      _heroBadge(
                                        icon: Icons.home,
                                        right: 71,
                                        top: 34,
                                      ),
                                      _heroBadge(
                                        icon: Icons.verified,
                                        right: 2,
                                        top: 5,
                                      ),
                                      _heroBadge(
                                        icon: Icons.location_on,
                                        right: -1,
                                        top: 39,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildProgress(),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              border:
                                  Border.all(color: const Color(0xFFF0F3F1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildField(
                                  label: 'Full Name',
                                  controller: nameCtrl,
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 12),
                                _buildPhoneField(),
                                const SizedBox(height: 12),
                                _buildField(
                                  label: 'Password',
                                  controller: passCtrl,
                                  hint: 'Create a password',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  suffix: IconButton(
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints.tightFor(
                                      width: 30,
                                      height: 30,
                                    ),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: kMutedText,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 29, top: 3),
                                  child: Text(
                                    'Password must be at least 6 characters',
                                    style: TextStyle(
                                      color: kMutedText,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => widget.onNavigate(3),
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
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: kMutedText,
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'By continuing, you agree to our ',
                                  ),
                                  TextSpan(
                                    text: 'Terms & Privacy Policy',
                                    style: TextStyle(color: kForestGreen),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
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

  Widget _heroBadge({
    required IconData icon,
    required double right,
    required double top,
  }) {
    return Positioned(
      right: right,
      top: top,
      child: Container(
        width: 19,
        height: 19,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: kForestGreen, size: 13),
      ),
    );
  }

  Widget _buildProgress() {
    const labels = ['Basic Info', 'Location', 'Done'];

    return Column(
      children: [
        Row(
          children: List.generate(labels.length, (index) {
            final isCurrent = index == 0;
            return Expanded(
              child: Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kBorderColor,
                      ),
                    ),
                  Container(
                    width: 14,
                    height: 14,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCurrent ? kForestGreen : const Color(0xFFE4EBE7),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent ? Colors.white : kMutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (index < labels.length - 1)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: kBorderColor,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 2),
        Row(
          children: List.generate(labels.length, (index) {
            return Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index == 0 ? kForestGreen : kMutedText,
                  fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 10,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kDarkInk,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: kDarkInk, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kMutedText, fontSize: 12),
              isDense: true,
              prefixIcon: Icon(icon, color: kDarkInk, size: 18),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 44,
              ),
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 23,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: kBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: kBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: kForestGreen),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(
            color: kDarkInk,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kBorderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 6),
                const Icon(Icons.phone_outlined, color: kDarkInk, size: 18),
                const SizedBox(width: 4),
                Container(width: 1, height: 14, color: kBorderColor),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Text(
                        '+92',
                        style: TextStyle(color: kDarkInk, fontSize: 12),
                      ),
                      Icon(Icons.arrow_drop_down, size: 16, color: kDarkInk),
                    ],
                  ),
                ),
                Container(width: 1, height: 14, color: kBorderColor),
                Expanded(
                  child: TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: kDarkInk, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Enter your mobile number',
                      hintStyle: TextStyle(color: kMutedText, fontSize: 12),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 12,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
