import 'package:flutter/material.dart';
import 'package:soluciones_moviles_mod_proveedores/database/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _paswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _login() async {
    String usuario = _usuarioController.text.trim();
    String password = _paswordController.text.trim();

    bool esValido = await _dbHelper.validarUsuario(usuario, password);

    if (esValido) {
      Navigator.pushNamed(context, '/'); 
    } else {
      _mostrarError('Usuario o contraseña incorrectos');
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                hintText: 'Ingrese su usuario',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _paswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingrese su contraseña',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}