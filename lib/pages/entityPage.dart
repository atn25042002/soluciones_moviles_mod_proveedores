import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/DB/db.dart';

class Entitypage extends StatelessWidget {
  final String nombre;
  final Color color;

  const Entitypage({super.key, required this.nombre, required this.color});

  @override
  Widget build(BuildContext context) {
    // Lista de elementos a mostrar
    List<dynamic> elementos;
    switch (nombre) {
      case 'Paises':
        elementos = DB.obtenerPaises();
        break;
      case 'Proveedores':
        elementos = DB.obtenerProveedores();
        break;
      case 'Categorias':
        elementos = DB.obtenerCategorias();
        break;
      default:
        elementos = [];
        break;
    }
    print(elementos);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nombre,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0), // Color del texto
          ),
        ),
        centerTitle: true, // Centra el título
        backgroundColor: color, // Cambia el color de fondo
        toolbarHeight: 60.0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda con ícono de filtro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar $nombre...",
                      border: const OutlineInputBorder(),
                    ),
                    cursorHeight: 10,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_alt_sharp),
                  onPressed: () {
                    // Lógica de filtros aquí
                    print('Filtro activado');
                  },
                ),
              ],
            ),
          ),

          // Título debajo de la barra de búsqueda
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Lista de $nombre",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ListView que muestra la lista de proveedores
          Expanded(
            child: ListView.builder(
              itemCount: elementos.length,
              itemBuilder: (context, index) {
                print(elementos);
                return ListTile(
                  title: Text(elementos[index].nombre),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
