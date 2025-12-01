import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = '/booking';

  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva / Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PrimaryTextField(label: 'Nombre'),
            const SizedBox(height: 12),
            const PrimaryTextField(label: 'Producto deseado'),
            const SizedBox(height: 12),
            const PrimaryTextField(
              label: 'Cantidad',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Descripción / Detalles',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Enviar solicitud',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Solicitud enviada (demo)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
