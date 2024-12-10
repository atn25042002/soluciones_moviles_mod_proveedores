import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  Map<String, String> nombresTablas = {
    'Paises': 'Paises',
    'CategoriasProductos': 'CategoriasProductos',
    'MaestroProveedores': 'MaestroProveedores',
    'pais': 'Paises',
    'categoria': 'CategoriasProductos',
    'proveedor': 'MaestroProveedores'
  };

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'proveedores.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Paises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        estado_registro TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE CategoriasProductos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        estado_registro TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE MaestroProveedores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        ruc TEXT NOT NULL,
        categoria_id INTEGER NOT NULL,
        pais_id INTEGER NOT NULL,
        estado_registro TEXT NOT NULL,
        FOREIGN KEY (categoria_id) REFERENCES CategoriasProductos (id),
        FOREIGN KEY (pais_id) REFERENCES Paises (id)
      )
    ''');
  }

  Future<void> insertPais(Map<String, dynamic> values) async {
    final db = await database;
    await db.insert('Paises', values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCategoriaProducto(Map<String, dynamic> values) async {
    final db = await database;
    await db.insert('CategoriasProductos', values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertProveedor(Map<String, dynamic> values) async {
    final db = await database;
    await db.insert('MaestroProveedores', values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insertar un registro (generalizado)
  Future<void> insertRecord(String table, Map<String, dynamic> values) async {
    print("esto datos se guarda en DB");
    print(values);
    final db = await database;
    await db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Actualizar un registro (generalizado)
  Future<void> updateRecord(
      String table, int id, Map<String, dynamic> values) async {
    final db = await database;
    await db.update(
      table,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Ver un registro por ID
  Future<Map<String, dynamic>?> getRecordById(String table, int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

// Ver todos los registros (filtrados por estado si es necesario)
  Future<List<Map<String, dynamic>>> getAllRecords(String table,
      {String? estadoRegistro, String? orden}) async {
    final db = await database;
    return await db.query(
      table,
      where: estadoRegistro != null ? 'estado_registro = ?' : null,
      whereArgs: estadoRegistro != null ? [estadoRegistro] : null,
      orderBy: orden,
    );
  }

// Cambiar el estado de un registro (activo/inactivo)
  Future<void> changeRecordState(
      String table, int id, String nuevoEstado) async {
    final db = await database;
    await db.update(
      table,
      {'estado_registro': nuevoEstado},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getFieldsAndForeignKeys(
      String table) async {
    final db = await database;
    // Obtener los campos de la tabla con sus tipos de datos
    List<Map<String, dynamic>> fields =
        await db.rawQuery('PRAGMA table_info($table);');
    return fields;
  }

  String getNombreTablas(String nombre) {
    print("buscando $nombre");
    String rpta = nombresTablas[nombre] ?? '';
    print("Devolviendo $rpta");
    return nombresTablas[nombre] ?? '';
  }
}
