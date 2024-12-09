import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/pages/entityPage.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String nombre;

  const RoundedButton({
    super.key,
    required this.color,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Color de fondo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
        ),
        padding:
            const EdgeInsets.symmetric(vertical: 16.0), // Espaciado interno
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EntityPage(nombre: nombre, color: color)),
        );
      },
      child: Text(
        nombre,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0), // Color del texto
        ),
      ),
    );
  }
}
