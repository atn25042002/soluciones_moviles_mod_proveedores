import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/DB/db.dart';

class Edition extends StatelessWidget {
  final String nombreTabla;
  final String codigo;

  // Constructor para recibir los parámetros
  const Edition({Key? key, required this.nombreTabla, required this.codigo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Aquí podrías obtener los valores de la tabla según el codigo
    // Por ejemplo, podrías usar el codigo para acceder a los datos específicos del registro
    // En este caso, estoy usando datos de ejemplo.
    
    // Simulación de campos de la tabla
    final Map<String,dynamic> camposRecuperados;
      switch (nombreTabla) {
      case 'Paises':
        camposRecuperados = DB.obtenerPaisPorCodigo(codigo) ?? {};
        break;
        default:
        camposRecuperados = {}; // Valor por defecto si no hay coincidencias
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(nombreTabla), // Mostrar el nombre de la tabla en el AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la edición de la tabla
            Text(
              'Edición de $nombreTabla',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Mostrar los campos de la tabla
            Expanded(
              child: ListView(
                children: camposRecuperados.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: TextStyle(fontSize: 16)),
                        Text(entry.value, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Botones para "Grabar" y "Salir"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para grabar los cambios (puedes agregar aquí tu lógica)
                    print('Grabar cambios');
                  },
                  child: Text('Grabar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar hacia atrás (salir)
                    Navigator.pop(context);
                  },
                  child: Text('Salir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
