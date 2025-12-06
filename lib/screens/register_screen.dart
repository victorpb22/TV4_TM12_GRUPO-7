import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/primary_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cedulaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrarCliente() async {
    final nombre = _nameController.text.trim();
    final cedula = _cedulaController.text.trim();
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final pass2 = _confirmPasswordController.text.trim();

    // Validación básica
    if (nombre.isEmpty ||
        cedula.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        pass2.isEmpty) {
      _showSnack('Completa todos los campos');
      return;
    }

    if (pass != pass2) {
      _showSnack('Las contraseñas no coinciden');
      return;
    }

    // Ejemplo de validación de cédula (solo largo, tú puedes ajustarlo)
    if (cedula.length < 10) {
      _showSnack('La cédula debe tener al menos 10 dígitos');
      return;
    }

    try {
      setState(() => _isLoading = true);

      // Crear usuario en Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      _showSnack('Registro correcto');

      if (!mounted) return;
      // Puedes hacer pop o ir al Home
      // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } on FirebaseAuthException catch (e) {
      // Para ver qué pasa, se imprime en la consola
      print('FIREBASE AUTH ERROR -> code: ${e.code}, message: ${e.message}');

      String msg = 'Error al registrarse';

      if (e.code == 'email-already-in-use') {
        msg = 'El correo ya está registrado';
      } else if (e.code == 'weak-password') {
        msg = 'La contraseña es muy débil';
      } else if (e.code == 'operation-not-allowed') {
        msg = 'El método Email/Contraseña no está habilitado en Firebase';
      }

      _showSnack(msg);
    } catch (e) {
      print('ERROR DESCONOCIDO -> $e');
      _showSnack('Error inesperado: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Completa los campos para crear tu cuenta'),
            const SizedBox(height: 24),

            // Nombre completo
            PrimaryTextField(
              label: 'Nombre completo',
              controller: _nameController,
            ),
            const SizedBox(height: 16),

            // Cédula – solo números
            PrimaryTextField(
              label: 'Cédula',
              controller: _cedulaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            // Email
            PrimaryTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Contraseña
            PrimaryTextField(
              label: 'Contraseña',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Confirmar contraseña
            PrimaryTextField(
              label: 'Confirmar contraseña',
              controller: _confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: _isLoading ? 'Registrando...' : 'Registrarme',
              onPressed: _isLoading ? null : _registrarCliente,
            ),
          ],
        ),
      ),
    );
  }
}
