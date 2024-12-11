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
  List<Map<String, dynamic>> filteredElements = []; // Lista filtrada
  String tabla = "";
  bool isLoading = true;
  final dbHelper = DatabaseHelper();
  final TextEditingController searchController =
      TextEditingController(); // Controlador de búsqueda

  String modoBusqueda = 'nombre'; // Opción seleccionada inicialmente
  String modoOrden = 'nombre';

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(
        _filterList); // Agregar listener al controlador de búsqueda
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> data;
    String nombretabla;
    switch (widget.nombre) {
      case 'Paises':
        nombretabla = "Paises";
        data = await dbHelper.getAllRecords("Paises", orden: "nombre");
        break;
      case 'Proveedores':
        nombretabla = "MaestroProveedores";
        data =
            await dbHelper.getAllRecords("MaestroProveedores", orden: "nombre");
        break;
      case 'Categorias':
        nombretabla = "CategoriasProductos";
        data = await dbHelper.getAllRecords("CategoriasProductos",
            orden: "nombre");
        break;
      default:
        nombretabla = "";
        data = [];
        break;
    }
    setState(() {
      elementos = data;
      filteredElements =
          data; // Inicialmente, la lista filtrada es igual a la lista completa
      tabla = nombretabla;
      isLoading = false;
    });
  }

  // Método para filtrar la lista según lo que escribe el usuario
  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredElements = elementos.where((elemento) {
        return elemento[modoBusqueda]
            .toLowerCase()
            .contains(query); // Filtra por el nombre
      }).toList();
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
                          controller: searchController, // Asocia el controlador
                          decoration: InputDecoration(
                            hintText: "🔍 Buscar ${widget.nombre}...",
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            modoBusqueda = value;
                            _filterList();
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            enabled:
                                false, // Deshabilita la opción para que actúe como título
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Busqueda por:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          PopupMenuItem(value: 'nombre', child: Text('Nombre')),
                          PopupMenuItem(value: 'codigo', child: Text('Codigo')),
                          PopupMenuItem(
                              value: 'estado_registro',
                              child: Text('Estado de Registro')),
                        ],
                        icon: Icon(
                          Icons.manage_search,
                          size: 30,
                        ), // Ícono que activa el menú
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            modoOrden = value;
                            filteredElements.sort((a, b) {
                              return a[modoOrden]
                                  .toLowerCase()
                                  .compareTo(b[modoOrden].toLowerCase());
                            });
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            enabled:
                                false, // Deshabilita la opción para que actúe como título
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ordenar por:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          PopupMenuItem(value: 'nombre', child: Text('Nombre')),
                          PopupMenuItem(value: 'codigo', child: Text('Codigo')),
                          PopupMenuItem(
                              value: 'estado_registro',
                              child: Text('Estado de Registro')),
                        ],
                        icon: Icon(
                          Icons.sort_by_alpha_rounded,
                          size: 30,
                        ), // Ícono que activa el menú
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

                // ListView que muestra los datos filtrados
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredElements.length, // Usa la lista filtrada
                    itemBuilder: (context, index) {
                      var elemento = filteredElements[index];
                      return ExpansionTile(
                        title: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: elemento['estado_registro'] == "A"
                                ? const Color(0xFFA3F7C6)
                                : (elemento['estado_registro'] == "I"
                                    ? const Color(0xFFFFC364)
                                    : const Color(0xFFFF7E64)),
                            borderRadius:
                                BorderRadius.circular(12), // Puntas redondeadas
                          ),
                          padding:
                              const EdgeInsets.all(10.0), // Espaciado interno
                          child: Text(
                            elemento['nombre'],
                            style: const TextStyle(
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Color del texto
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Código: ${elemento['codigo']}'),
                              Text('Estado: ${elemento['estado_registro']}'),
                              IconButton(
                                onPressed: () async {
                                  final resultado = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Edition(
                                        nombreTabla: tabla,
                                        id: elemento['id'],
                                        edicion: true,
                                      ),
                                    ),
                                  );
                                  if (resultado == true) {
                                    _loadData();
                                  }
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

  @override
  void dispose() {
    searchController.removeListener(_filterList); // Eliminar el listener
    searchController.dispose(); // Limpiar el controlador
    super.dispose();
  }
}
