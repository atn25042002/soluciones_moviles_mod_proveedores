import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/database/database_helper.dart';
import 'package:soluciones_moviles_mod_proveedores/pages/edition.dart';

class EntityPage extends StatefulWidget {
  final String nombre;
  final Color color;

  const EntityPage({super.key, required this.nombre, required this.color});

  @override
  _EntityPageState createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage> {
  List<Map<String, dynamic>> elementos = [];
  String tabla = "";
  bool isLoading = true;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> data;
    print("todo esto se cargara");
    String nombretabla;
    switch (widget.nombre) {
      case 'Paises':
        nombretabla = "Paises";
        data = await dbHelper.getAllRecords("Paises");
        break;
      case 'Proveedores':
        nombretabla = "MaestroProveedores";
        data = await dbHelper.getAllRecords("MaestroProveedores");
        break;
      case 'Categorias':
        nombretabla = "CategoriasProductos";
        data = await dbHelper.getAllRecords("CategoriasProductos");
        break;
      default:
        nombretabla = "";
        data = [];
        break;
    }
    print(data);
    setState(() {
      elementos = data;
      tabla = nombretabla;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombre,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: widget.color,
        toolbarHeight: 60.0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Buscar ${widget.nombre}...",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt_sharp),
                        onPressed: () {
                          print('Filtro activado');
                        },
                      ),
                    ],
                  ),
                ),

                // Título debajo de la barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Lista de ${widget.nombre}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ListView que muestra los datos
                Expanded(
                  child: ListView.builder(
                    itemCount: elementos.length,
                    itemBuilder: (context, index) {
                      var elemento = elementos[index];
                      return ExpansionTile(
                        title: Text(elemento['nombre']),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Código: ${elemento['codigo']}'),
                              Text(
                                  'Estado: ${elemento['estado_registro'] }'),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Edition(
                                        nombreTabla: tabla,
                                        id: elemento['id'],
                                        edicion: true,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

      // Botón flotante para agregar un nuevo registro
      floatingActionButton: FloatingActionButton(
         onPressed: () async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Edition(
          nombreTabla: tabla,
          id: -1,
          edicion: false,
        ),
      ),
    );

    // Si hubo cambios, recargar los datos
    if (resultado == true) {
      _loadData();
    }
  },
        backgroundColor: widget.color,
        child: const Icon(Icons.add),

      ),
    );
  }
}
