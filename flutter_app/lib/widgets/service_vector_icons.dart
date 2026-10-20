import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F3),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: _buildInnerGraphic(serviceId),
    );
  }

  Widget _buildInnerGraphic(String id) {
    switch (id) {
      case 's1':
        return const Text('💡', style: TextStyle(fontSize: 25));
      case 's2':
        return const Text('🚰', style: TextStyle(fontSize: 25));
      case 's3':
        return Container(
          width: 30,
          height: 19,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F6FA),
            border: Border.all(color: const Color(0xFF4CB7C8), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.ac_unit,
            color: Color(0xFF27AFC3),
            size: 13,
          ),
        );
      case 's4':
        return const Text('🖌️', style: TextStyle(fontSize: 25));
      case 's5':
        return const Text('🛠️', style: TextStyle(fontSize: 25));
      case 's6':
        return const Text('🪚', style: TextStyle(fontSize: 25));
      case 's7':
        return const Text('🎓', style: TextStyle(fontSize: 25));
      case 's8':
        return const Text('🧵', style: TextStyle(fontSize: 25));
      case 's9':
        return const Text('👨‍🍳', style: TextStyle(fontSize: 25));
      case 's10':
        return const Text('🧹', style: TextStyle(fontSize: 25));
      case 's11':
        return const Text('🌱', style: TextStyle(fontSize: 25));
      case 's12':
        return const Text(
          '•••',
          style: TextStyle(
            color: Color(0xFF78909C),
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        );
      default:
        return const Text('•••', style: TextStyle(color: Color(0xFF78909C)));
    }
  }
}
