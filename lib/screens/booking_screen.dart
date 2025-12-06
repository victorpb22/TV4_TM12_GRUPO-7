import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/primary_text_field.dart';

class BookingScreen extends StatefulWidget {
  static const String routeName = '/booking';

  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Controladores
  final _nombreController = TextEditingController();
  final _productoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _detallesController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _productoController.dispose();
    _cantidadController.dispose();
    _detallesController.dispose();
    super.dispose();
  }

  void _enviarSolicitud() {
    if (_nombreController.text.isEmpty ||
        _productoController.text.isEmpty ||
        _cantidadController.text.isEmpty ||
        _detallesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada correctamente')),
    );

    // limpiar campos
    _nombreController.clear();
    _productoController.clear();
    _cantidadController.clear();
    _detallesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reserva / Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PrimaryTextField(label: 'Nombre', controller: _nombreController),
              const SizedBox(height: 12),

              PrimaryTextField(
                label: 'Producto deseado',
                controller: _productoController,
              ),
              const SizedBox(height: 12),

              PrimaryTextField(
                label: 'Cantidad',
                controller: _cantidadController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _detallesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción / Detalles',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              PrimaryButton(
                text: 'Enviar solicitud',
                onPressed: _enviarSolicitud,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
