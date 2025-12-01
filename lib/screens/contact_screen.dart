import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';

class ContactScreen extends StatelessWidget {
  static const String routeName = '/contact';

  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PrimaryTextField(label: 'Nombre'),
            const SizedBox(height: 12),
            const PrimaryTextField(
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Enviar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mensaje enviado (demo)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
