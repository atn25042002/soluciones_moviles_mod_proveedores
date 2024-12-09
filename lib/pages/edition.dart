import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/database/database_helper.dart';

class Edition extends StatefulWidget {
  final String nombreTabla;
  final int id; // Código del registro para edición
  final bool
      edicion; // Si es true, está en modo edición, si es false, en modo creación

  const Edition({
    super.key,
    required this.nombreTabla,
    required this.id,
    required this.edicion,
  });

  @override
  _EditionState createState() => _EditionState();
}

class _EditionState extends State<Edition> {
  late Map<String, TextEditingController> controllers;
  late Map<String, dynamic> camposRecuperados = {};
  late List<String> camposTabla =
      []; // Para guardar los campos y claves foráneas de la tabla

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    controllers = {};
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Obtener los campos de la tabla desde la base de datos
      print("1");
      var result = await dbHelper.getFieldsAndForeignKeys(widget.nombreTabla);
      print("2 Salida result: $result");
      camposTabla = result.map((item) => item['name'] as String).toList();
      camposTabla.remove('id');
      print("Salida campos: $camposTabla");
      if (widget.edicion) {
        // En modo edición, cargar los valores existentes
        camposRecuperados =
            await dbHelper.getRecordById(widget.nombreTabla, widget.id) ?? {};
        // Crear controladores con los valores existentes
        for (var campo in camposTabla) {
          controllers[campo] = TextEditingController(
              text: camposRecuperados[campo]?.toString() ?? '');
        }
      } else {
        print("3");
        // En modo creación, los campos estarán vacíos
        for (var campo in camposTabla) {
          controllers[campo] = TextEditingController(text: '');
        }
        print("4");
      }

      setState(() {});
    } catch (e) {
      print('Error al cargar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  void grabarCambios() async {
    Map<String, dynamic> nuevosValores = {};
    controllers.forEach((key, controller) {
      nuevosValores[key] = controller.text;
    });

    if (widget.edicion) {
      // Actualizar registro existente
      await dbHelper.updateRecord(widget.nombreTabla, widget.id, nuevosValores);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado correctamente')),
      );
    } else {
      // Insertar un nuevo registro
      await dbHelper.insertRecord(widget.nombreTabla, nuevosValores);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro creado correctamente')),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreTabla),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: camposTabla.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la edición o creación
                  Text(
                    widget.edicion
                        ? 'Edición de ${widget.nombreTabla}'
                        : 'Agregar ${widget.nombreTabla}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Formulario dinámico
                  Expanded(
                    child: ListView(
                      children: camposTabla.map((campo) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(campo, style: const TextStyle(fontSize: 16)),
                              Expanded(
                                child: TextField(
                                  controller: controllers[campo],
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: widget.edicion
                                        ? camposRecuperados[campo]
                                                ?.toString() ??
                                            ''
                                        : '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: grabarCambios,
                        child: const Text('Grabar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
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
