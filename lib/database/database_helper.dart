import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'proveedores.db');
    await deleteDatabase(path);
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
        estado_registro INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE CategoriasProductos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        estado_registro INTEGER NOT NULL
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
        estado_registro INTEGER NOT NULL,
        FOREIGN KEY (categoria_id) REFERENCES CategoriasProductos (id),
        FOREIGN KEY (pais_id) REFERENCES Paises (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      INSERT INTO Usuarios (usuario, password) VALUES ('admin', 'admin')
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
      {int? estadoRegistro}) async {
    final db = await database;
    return await db.query(
      table,
      where: estadoRegistro != null ? 'estado_registro = ?' : null,
      whereArgs: estadoRegistro != null ? [estadoRegistro] : null,
    );
  }

// Cambiar el estado de un registro (activo/inactivo)
  Future<void> changeRecordState(String table, int id, int nuevoEstado) async {
    final db = await database;
    await db.update(
      table,
      {'estado_registro': nuevoEstado},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> validarUsuario(String usuario, String pas) async {
    final db = await database;
    final res = await db.query(
      'Usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, pas],
    );
    return res.isNotEmpty; // Devuelve true si el usuario y contraseña coinciden
  }
}
