import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/components/dropDownList.dart';
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
  late Map<String, dynamic> controllers;
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
          if (campo.endsWith("_id")) {
            controllers[campo] = camposRecuperados[campo]?.toString() ?? '';
          } else {
            controllers[campo] = TextEditingController(
                text: camposRecuperados[campo]?.toString() ?? '');
          }
        }
      } else {
        print("3");
        // En modo creación, los campos estarán vacíos
        for (var campo in camposTabla) {
          if (campo.endsWith("_id")) {
            controllers[campo] = "";
          } else {
            controllers[campo] = TextEditingController(text: '');
          }
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

  Future<Map<String, dynamic>?> recuperarUnRegistro(String codigoSync) async {
    try {
      // Llamamos al método getRecordPorCodigo de dbHelper
      Map<String, dynamic>? record =
          await dbHelper.getRecordPorCodigo(widget.nombreTabla, codigoSync);
      print("esto se recupero");
      print(record);

      return record; // Devuelve el registro encontrado o null si no se encuentra
    } catch (e) {
      print('Error al recuperar el registro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al recuperar el registro: $e')),
      );
      return null; // Si ocurre un error, también devuelve null
    }
  }

  void grabarCambios() async {
    Map<String, dynamic> nuevosValores = {};
    controllers.forEach((key, controller) {
      if (controller is TextEditingController) {
        nuevosValores[key] = controller.text;
      } else {
        nuevosValores[key] = controller;
      }
    });
    print("los valores a guarda son");
    print(nuevosValores);

    if (widget.edicion) {
      // Actualizar registro existente
      await dbHelper.updateRecord(widget.nombreTabla, widget.id, nuevosValores);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro actualizado correctamente')),
      );
      Navigator.pop(context, true);
    } else {
      var recod = await recuperarUnRegistro(nuevosValores['codigo']);
      print("hay duplicado");
      print(recod);
      if (recod != null) {
        _showDuplicateRecordDialog();
      } else {
        nuevosValores['estado_registro'] = 'A';
        // Insertar un nuevo registro
        await dbHelper.insertRecord(widget.nombreTabla, nuevosValores);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro creado correctamente')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  void eliminarRecord() async {
    await dbHelper.changeRecordState(widget.nombreTabla, widget.id, "*");
    Navigator.pop(context, true);
  }

  void activarRecord() async {
    await dbHelper.changeRecordState(widget.nombreTabla, widget.id, "A");
    Navigator.pop(context, true);
  }

  void desactivarRecord() async {
    await dbHelper.changeRecordState(widget.nombreTabla, widget.id, "I");
    Navigator.pop(context, true);
  }

  // Función para mostrar un diálogo de error si hay un registro duplicado
  void _showDuplicateRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text(
              "No puede haber un registro duplicado con el mismo código."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
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
                      children: (!widget.edicion
                              ? camposTabla.sublist(0, camposTabla.length - 1)
                              : camposTabla)
                          .map((campo) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  campo.endsWith('_id')
                                      ? campo.substring(0, campo.length - 3)
                                      : campo,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 20),
                              Expanded(
                                  child: controllers[campo]
                                          is TextEditingController
                                      ? TextField(
                                          controller: controllers[campo],
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            hintText: widget.edicion
                                                ? camposRecuperados[campo]
                                                        ?.toString() ??
                                                    ''
                                                : '',
                                          ),
                                        )
                                      : DropdownList(
                                          tableName: dbHelper.getNombreTablas(
                                              campo.substring(
                                                  0, campo.length - 3)),
                                          onValueChanged: (selectedId) {
                                            controllers[campo] = selectedId;
                                          },
                                          initialValue: widget.edicion
                                              ? camposRecuperados[campo]
                                                  .toString()
                                              : null,
                                        )),
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
                          child: const Icon(
                            Icons.save,
                            size: 50,
                          )),
                      if (widget.edicion)
                        ElevatedButton(
                            onPressed: () {
                              camposRecuperados['estado_registro'] == 'A'
                                  ? desactivarRecord()
                                  : activarRecord();
                            },
                            child: Icon(
                              camposRecuperados['estado_registro'] == 'A'
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 50,
                            )),
                      if (widget.edicion)
                        ElevatedButton(
                            onPressed: () {
                              eliminarRecord();
                            },
                            child: const Icon(
                              Icons.delete_forever,
                              size: 50,
                            )),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.exit_to_app,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
