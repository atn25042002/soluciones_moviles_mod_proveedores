class Pais {
  String codigo;
  String nombre;
  String estadoRegistro;

  // Constructor para inicializar los campos
  Pais({
    required this.codigo,
    required this.nombre,
    required this.estadoRegistro,
  });
  
  Map<String, dynamic>? toMap() {
        return {
      'codigo': codigo,
      'nombre': nombre,
      'estadoRegistro': estadoRegistro,
    };
  }
}
class Proveedor {
  String codigo;
  String nombre;
  String ruc;
  String categoria;
  String pais;
  String estadoRegistro;

  // Constructor para inicializar los campos
  Proveedor({
    required this.codigo,
    required this.nombre,
    required this.ruc,
    required this.categoria,
    required this.pais,
    required this.estadoRegistro,
  });
}
class CategoriaProducto {
  String codigo;
  String nombre;
  String estadoRegistro;

  // Constructor para inicializar los campos
  CategoriaProducto({
    required this.codigo,
    required this.nombre,
    required this.estadoRegistro,
  });
}
class DB {
  // Lista simulada de proveedores
  static List<Proveedor> proveedores = [
    Proveedor(codigo: 'P001', nombre: 'Proveedor 1', ruc: '123456789', categoria: 'Electrónica', pais: 'Perú', estadoRegistro: 'Activo'),
    Proveedor(codigo: 'P002', nombre: 'Proveedor 2', ruc: '987654321', categoria: 'Alimentos', pais: 'Argentina', estadoRegistro: 'Inactivo'),
    // Agrega más proveedores según sea necesario
  ];

  // Lista simulada de categorías de productos
  static List<CategoriaProducto> categorias = [
    CategoriaProducto(codigo: 'C001', nombre: 'Electrónica', estadoRegistro: 'Activo'),
    CategoriaProducto(codigo: 'C002', nombre: 'Ropa', estadoRegistro: 'Activo'),
    // Agrega más categorías según sea necesario
  ];

  // Método para obtener todos los proveedores
  static List<Proveedor> obtenerProveedores() {
    return proveedores;
  }

  // Método para agregar un nuevo proveedor
  static void agregarProveedor(Proveedor proveedor) {
    proveedores.add(proveedor);
  }

  // Método para actualizar el estado de registro de un proveedor
  static void actualizarEstadoRegistroProveedor(String codigo, String nuevoEstado) {
    for (var proveedor in proveedores) {
      if (proveedor.codigo == codigo) {
        proveedor.estadoRegistro = nuevoEstado;
        break;
      }
    }
  }

  // Método para eliminar un proveedor
  static void eliminarProveedor(String codigo) {
    proveedores.removeWhere((proveedor) => proveedor.codigo == codigo);
  }

  // Método para obtener todas las categorías de productos
  static List<CategoriaProducto> obtenerCategorias() {
    return categorias;
  }

  // Método para agregar una nueva categoría de producto
  static void agregarCategoria(CategoriaProducto categoria) {
    categorias.add(categoria);
  }

  // Método para actualizar el estado de registro de una categoría
  static void actualizarEstadoRegistroCategoria(String codigo, String nuevoEstado) {
    for (var categoria in categorias) {
      if (categoria.codigo == codigo) {
        categoria.estadoRegistro = nuevoEstado;
        break;
      }
    }
  }

  // Método para eliminar una categoría de producto
  static void eliminarCategoria(String codigo) {
    categorias.removeWhere((categoria) => categoria.codigo == codigo);
  }
  




  // Lista simulada de países
  static List<Pais> paises = [
    Pais(codigo: 'PE', nombre: 'Perú', estadoRegistro: 'Activo'),
    Pais(codigo: 'AR', nombre: 'Argentina', estadoRegistro: 'Activo'),
    Pais(codigo: 'BR', nombre: 'Brasil', estadoRegistro: 'Inactivo'),
    Pais(codigo: 'CO', nombre: 'Colombia', estadoRegistro: 'Eliminado'),
    Pais(codigo: 'CL', nombre: 'Chile', estadoRegistro: 'Activo'),
    // Agrega más países según sea necesario
  ];

  // Método para obtener todos los países
  static List<Pais> obtenerPaises() {
    return paises;
  }

  // Método para agregar un nuevo país
  static void agregarPais(Pais pais) {
    paises.add(pais);
  }

  // Método para actualizar el estado de registro de un país
  static void actualizarEstadoRegistro(String codigo, String nuevoEstado) {
    for (var pais in paises) {
      if (pais.codigo == codigo) {
        pais.estadoRegistro = nuevoEstado;
        break;
      }
    }
  }

  // Método para eliminar un país
  static void eliminarPais(String codigo) {
    paises.removeWhere((pais) => pais.codigo == codigo);
  }
    // Método para obtener un país dado su código y devolverlo como un mapa
  static Map<String, dynamic>? obtenerPaisPorCodigo(String codigo) {
      // Si el código es -1, devolver un mapa con claves y valores vacíos
  if (codigo == '-1') {
    return {
      'codigo': '',
      'nombre': '',
      'estadoRegistro': ''
    };
  }

    // Buscar y devolver el país cuyo código coincida, convertido a mapa
    for (var pais in paises) {
      if (pais.codigo == codigo) {
        return pais.toMap(); // Convertimos el objeto Pais en un mapa
      }
    }
    return null; // Si no se encuentra el país, devolver null
  }
}