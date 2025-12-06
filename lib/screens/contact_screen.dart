import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';

class ContactScreen extends StatefulWidget {
  static const String routeName = '/contact';

  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Controladores
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _mensajeController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  void _enviarMensaje() {
    if (_nombreController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _mensajeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mensaje enviado correctamente')),
    );

    // limpiar
    _nombreController.clear();
    _correoController.clear();
    _mensajeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PrimaryTextField(label: 'Nombre', controller: _nombreController),
            const SizedBox(height: 12),

            PrimaryTextField(
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
              controller: _correoController,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _mensajeController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            PrimaryButton(text: 'Enviar', onPressed: _enviarMensaje),
          ],
        ),
      ),
    );
  }
}
