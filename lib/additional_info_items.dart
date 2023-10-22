import 'package:flutter/material.dart';

class AdditionalInfoItems extends StatelessWidget {
  //constructors for info
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfoItems({
    super.key,
    required this.icon,
    required this.label,
    required this.value, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 35),
        const SizedBox(height: 8), 
        Text(label,style: const TextStyle(fontSize: 16),),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize:20 , fontWeight: FontWeight.bold),),
      ],
    );
  }
}