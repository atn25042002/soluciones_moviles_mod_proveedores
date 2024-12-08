import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/DB/db.dart';

class Edition extends StatelessWidget {
  final String nombreTabla;
  final String codigo;
  final bool edicion;

  // Constructor para recibir los parámetros
  const Edition(
      {super.key,
      required this.nombreTabla,
      required this.codigo,
      required this.edicion});

  @override
  Widget build(BuildContext context) {
    // Aquí podrías obtener los valores de la tabla según el codigo
    // Por ejemplo, podrías usar el codigo para acceder a los datos específicos del registro
    // En este caso, estoy usando datos de ejemplo.

    late Map<String, TextEditingController> controllers;
    // Simulación de campos de la tabla
    final Map<String, dynamic> camposRecuperados;
      switch (nombreTabla) {
        case 'Paises':
          camposRecuperados = DB.obtenerPaisPorCodigo(codigo) ?? {};
          break;
        default:
          camposRecuperados = {}; // Valor por defecto si no hay coincidencias
      }
      print(camposRecuperados);
          // Inicializar los controladores con los valores actuales
    controllers = {};
    for (var entry in camposRecuperados.entries) {
      controllers[entry.key] = TextEditingController(text: entry.value.toString());
    }
      void grabarCambios() {
        print("campos anteriores");
        print(camposRecuperados);
    // Crear un nuevo mapa con los valores actualizados
    Map<String, dynamic> nuevosValores = {};
    for (var entry in controllers.entries) {
      nuevosValores[entry.key] = entry.value.text;
    }
    print("nuevos campos");
    print(nuevosValores);

    // Aquí puedes implementar la lógica para guardar los cambios
    // Por ejemplo:
    switch (nombreTabla) {
      case 'Paises':
        // Llamar a tu método de DB para actualizar
        //DB.actualizarPais(codigo, nuevosValores);
        break;
    }

    // Mostrar un snackbar de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cambios guardados correctamente')),
    );

    // Opcional: volver a la pantalla anterior
    Navigator.pop(context);
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
              edicion ? 'Edición de $nombreTabla' : 'Agregar $nombreTabla',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mostrar los campos de la tabla
            Expanded(
              child: ListView(
                children: camposRecuperados.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 16)),
                        Expanded(
                          child: TextField(
                            controller: controllers[entry.key],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: entry.value
                            ),
                          ),
                        )
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
                    grabarCambios();
                    // Lógica para grabar los cambios (puedes agregar aquí tu lógica)
                    print('Grabar cambios');
                  },
                  child: const Text('Grabar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar hacia atrás (salir)
                    Navigator.pop(context);
                  },
                  child: const Text('Salir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
