import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <- para FilteringTextInputFormatter

import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';
import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = '/register';

  RegisterScreen({super.key});

  // Llave del formulario para poder validar
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de cliente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // ← conectamos el formulario con la llave
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
              const PrimaryTextField(label: 'Nombre completo'),
              const SizedBox(height: 16),

              // ------------ CÉDULA ------------
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  // Solo permite números
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10, // Máximo 10 dígitos
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu cédula';
                  }
                  if (value.length != 10) {
                    return 'La cédula debe tener 10 dígitos';
                  }
                  return null; // todo bien
                },
              ),
              const SizedBox(height: 16),
              // --------------------------------

              // Email
              const PrimaryTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Contraseña
              const PrimaryTextField(label: 'Contraseña', obscureText: true),
              const SizedBox(height: 16),

              // Confirmar contraseña
              const PrimaryTextField(
                label: 'Confirmar contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Botón Registrarme
              PrimaryButton(
                text: 'Registrarme',
                onPressed: () {
                  // Solo continúa si la cédula pasa la validación
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(
                      context,
                      HomeScreen.routeName,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
