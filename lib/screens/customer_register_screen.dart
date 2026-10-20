import 'package:flutter/material.dart';

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
  bool _submitted = false;
  String? _nameError;
  String? _phoneError;
  String? _passwordError;

  void _continue() {
    setState(() {
      _submitted = true;
      _nameError = nameCtrl.text.trim().length < 2
          ? 'Enter your full name'
          : null;
      final phone = phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
      _phoneError = RegExp(r'^3\d{9}$').hasMatch(phone)
          ? null
          : 'Enter a valid 10-digit mobile number';
      _passwordError = passCtrl.text.length < 6
          ? 'Password must be at least 6 characters'
          : null;
    });

    if (_nameError == null && _phoneError == null && _passwordError == null) {
      widget.onNavigate(3);
    }
  }

  Widget _buildError(String? message) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 3),
      child: Text(
        message,
        style: TextStyle(color: Colors.red.shade700, fontSize: 11),
      ),
    );
  }

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
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 360 ? 12.0 : 16.0;
            final contentHeight = constraints.maxHeight > 24
                ? constraints.maxHeight - 24
                : 0.0;
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
                          const RegistrationHeroHeader(
                            title: 'Register as Customer',
                            subtitle:
                                'Find trusted skilled professionals near you',
                            imageAlignment: Alignment(-0.85, 0.2),
                            badgeIcons: [
                              Icons.home,
                              Icons.verified,
                              Icons.location_on,
                            ],
                          ),
                          const SizedBox(height: 8),
                          buildStepProgress([
                            'Basic Info',
                            'Location',
                            'Done',
                          ], 0),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: const Color(0xFFF0F3F1),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildField(
                                  label: 'Full Name',
                                  controller: nameCtrl,
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline,
                                  onChanged: (value) {
                                    if (_submitted) {
                                      setState(() {
                                        _nameError = value.trim().length < 2
                                            ? 'Enter your full name'
                                            : null;
                                      });
                                    }
                                  },
                                ),
                                _buildError(_nameError),
                                const SizedBox(height: 12),
                                _buildPhoneField(),
                                _buildError(_phoneError),
                                const SizedBox(height: 12),
                                _buildField(
                                  label: 'Password',
                                  controller: passCtrl,
                                  hint: 'Create a password',
                                  icon: Icons.lock_outline,
                                  obscureText: _obscurePassword,
                                  onChanged: (value) {
                                    if (_submitted) {
                                      setState(() {
                                        _passwordError = value.length < 6
                                            ? 'Password must be at least 6 characters'
                                            : null;
                                      });
                                    }
                                  },
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
                                      fontSize: 11,
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
<<<<<<< HEAD
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _continue,
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
=======
                          buildPillButton(
                            'Continue',
                            () => widget.onNavigate(3),
>>>>>>> 8299b66 (Update code)
                          ),
                          const SizedBox(height: 12),
                          const Center(
                            child: Text(
                              'By continuing, you agree to our Terms & Privacy Policy',
                              style: TextStyle(color: kMutedText, fontSize: 11),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kDarkInk,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
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
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
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
                    onChanged: (value) {
                      if (_submitted) {
                        final phone = value.replaceAll(RegExp(r'\D'), '');
                        setState(() {
                          _phoneError = RegExp(r'^3\d{9}$').hasMatch(phone)
                              ? null
                              : 'Enter a valid 10-digit mobile number';
                        });
                      }
                    },
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
