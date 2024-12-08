import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/components/roundedBox.dart';
import 'package:soluciones_moviles_mod_proveedores/components/roundedButton.dart';
import 'package:soluciones_moviles_mod_proveedores/pages/entityPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Módulo Proveedores',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Color del texto
          ),
        ),
        centerTitle: true, // Centra el título
        backgroundColor: Colors.blue, // Cambia el color de fondo
        toolbarHeight: 60.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          RoundedButton(
            color: Color(0xFF3FE69E),
            nombre: 'Proveedores',
          ),
          SizedBox(height: 16),
          RoundedButton(
            color: Color(0xFF3FC2E6),
            nombre: 'Categorias',
          ),
          SizedBox(height: 16),
          RoundedButton(
            color: Color(0xFFE6E63F),
            nombre: 'Paises',
          ),
        ],
      ),
    );
  }
}
