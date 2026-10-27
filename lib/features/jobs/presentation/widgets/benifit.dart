import 'package:flutter/material.dart';

class BenefitRow extends StatelessWidget {
  const BenefitRow({
    required this.label,
    required this.value,
  });

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text('$label: ${value ? 'Included' : 'Not included'}')),
        ],
      ),
    );
  }
}