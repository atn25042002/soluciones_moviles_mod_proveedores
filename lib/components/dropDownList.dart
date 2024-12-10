import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/database/database_helper.dart';

class DropdownList extends StatefulWidget {
  final String tableName;
  final String? initialValue; // Valor inicial opcional para el Dropdown

  // Agrega una función de callback opcional para notificar los cambios
  final Function(String?)? onValueChanged;

  const DropdownList({
    super.key,
    required this.tableName,
    this.initialValue, // Recibe el valor inicial
    this.onValueChanged,
  });

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> records = [];
  String? selectedValue; // Valor seleccionado del Dropdown

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      // Obtén los registros de la base de datos
      print("Obteniendo registros de ");
      print(widget.tableName);
      records = await dbHelper.getAllRecords(widget.tableName,
          estadoRegistro: "A", orden: "nombre");

      print(records);

      if (widget.initialValue != null) {
        // Verificar si el valor inicial está en los registros
        if (records
            .any((record) => record['id'].toString() == widget.initialValue)) {
          selectedValue =
              widget.initialValue; // Asigna el valor inicial recibido
        } else {
          selectedValue =
              null; // Si el valor inicial no existe, dejarlo en null
        }
      } else {
        selectedValue =
            null; // Deja el valor seleccionado como null si no se pasa initialValue
      }

      setState(() {});
    } catch (e) {
      print("Error al obtener los registros: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: const Text(
        "Seleccione una opción",
        style: TextStyle(fontSize: 12),
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        // Notifica el cambio al widget externo
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(value);
        }
      },
      items: records.map((record) {
        return DropdownMenuItem<String>(
          value: record['id'].toString(), // Valor asociado
          child: Text(record['nombre']), // Texto mostrado
        );
      }).toList(),
    );
  }
}
