import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Color color;
  final String text;

  const RoundedBox({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Margen interno
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
