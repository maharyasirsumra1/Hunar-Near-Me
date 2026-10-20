import 'package:flutter/material.dart';

import '../providers/app_state.dart';

// ============================================================================
// COLOR CONSTANTS & THEME UI COMPONENTS
// ============================================================================

const Color kForestGreen = Color(0xFF006B4F);
const Color kLightGreenBackground = Color(0xFFF5FAF7);
const Color kCardGreenTint = Color(0xFFEBF6EF);
const Color kDarkInk = Color(0xFF123D30);
const Color kMutedText = Color(0xFF70847C);
const Color kBorderColor = Color(0xFFDFEAE4);

PreferredSizeWidget buildAppHeader(
  BuildContext context, {
  VoidCallback? onBack,
}) {
  final app = AppScope.of(context);
  return AppBar(
    leadingWidth: onBack != null ? 44 : null,
    leading: onBack != null
        ? IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: kDarkInk, size: 20),
            onPressed: onBack,
          )
        : null,
    titleSpacing: 4,
    title: Row(
      children: [
        const Icon(Icons.handyman_outlined, color: kForestGreen, size: 22),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
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
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 40),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
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
  );
}

Widget buildPillButton(
  String title,
  VoidCallback onTap, {
  IconData? leadingIcon,
  bool outline = false,
}) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: outline
        ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kForestGreen, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, color: kForestGreen, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: kForestGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward, color: kForestGreen, size: 18),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: kForestGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
  );
}

Widget buildStepProgress(List<String> steps, int currentStep) {
  return Row(
    children: List.generate(steps.length, (i) {
      final isDone = i <= currentStep;
      final isCurrent = i == currentStep;
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                if (i > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i <= currentStep ? kForestGreen : kBorderColor,
                    ),
                  ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isDone
                      ? kForestGreen
                      : const Color(0xFFE1E9E5),
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDone ? Colors.white : kDarkInk,
                    ),
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: i < currentStep ? kForestGreen : kBorderColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              steps[i],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? kForestGreen : kMutedText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }),
  );
}

Widget buildCustomInputField({
  required String label,
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
  bool isPhone = false,
  bool isPassword = false,
  String? footnote,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: kDarkInk,
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: kMutedText, fontSize: 12),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          prefixIcon: isPhone
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Icon(prefixIcon, color: kMutedText, size: 18),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kLightGreenBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '🇵🇰 +92',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: kDarkInk,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                )
              : Icon(prefixIcon, color: kMutedText, size: 20),
          prefixIconConstraints: isPhone
              ? const BoxConstraints(minWidth: 92, minHeight: 44)
              : null,
          suffixIcon: isPassword
              ? const Icon(
                  Icons.visibility_outlined,
                  color: kMutedText,
                  size: 20,
                )
              : null,
        ),
      ),
      if (footnote != null) ...[
        const SizedBox(height: 4),
        Text(footnote, style: const TextStyle(color: kMutedText, fontSize: 11)),
      ],
      const SizedBox(height: 14),
    ],
  );
}
