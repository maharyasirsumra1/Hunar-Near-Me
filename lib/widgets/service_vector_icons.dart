import 'package:flutter/material.dart';

// ============================================================================
// CUSTOM COMPOSITE VECTOR ICONS FOR ALL 12 SERVICE CATEGORIES
// Matches the Exact Reference Screenshot
// ============================================================================

class ServiceVectorIcon extends StatelessWidget {
  final String serviceId;
  final double size;

  const ServiceVectorIcon({
    super.key,
    required this.serviceId,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEBF6EF), // Light pastel mint green
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: _buildInnerGraphic(serviceId),
    );
  }

  Widget _buildInnerGraphic(String id) {
    switch (id) {
      case 's1': // Electrician - Glowing Yellow Bulb
        return const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFB300), size: 30);

      case 's2': // Plumber - Blue Water Tap
        return const Icon(Icons.water_drop, color: Color(0xFF1E88E5), size: 28);

      case 's3': // AC Repair - Cyan AC Snowflake
        return const Icon(Icons.ac_unit, color: Color(0xFF00ACC1), size: 28);

      case 's5': // Mechanic - Crossed Wrench & Screwdriver
        return const Icon(Icons.build_rounded, color: Color(0xFF2E4D40), size: 28);

      case 's4': // Painter - Green Paint Roller
        return const Icon(Icons.format_paint, color: Color(0xFF00897B), size: 28);

      case 's6': // Carpenter - Wood Saw & Ruler
        return const Icon(Icons.construction, color: Color(0xFF8D6E63), size: 28);

      case 's10': // Cleaning - Yellow Broom & Sparkles
        return const Icon(Icons.cleaning_services, color: Color(0xFFF57C00), size: 28);

      case 's7': // Tutor - Graduation Cap
        return const Icon(Icons.school, color: Color(0xFF004D40), size: 28);

      case 's8': // Tailor - Sewing Machine / Scissors
        return const Icon(Icons.content_cut, color: Color(0xFF004D40), size: 28);

      case 's9': // Cook - White Chef Hat
        return const Icon(Icons.restaurant, color: Color(0xFF263238), size: 28);

      case 's11': // Gardener - Plant Sprout
        return const Icon(Icons.eco, color: Color(0xFF2E7D32), size: 28);

      case 's12': // More - Three Horizontal Dots
      default:
        return const Icon(Icons.more_horiz, color: Color(0xFF78909C), size: 28);
    }
  }
}
