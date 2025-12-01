import 'package:flutter/material.dart';

class AdminProductForm extends StatelessWidget {
  static const String routeName = '/admin-product-form';

  const AdminProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de productos'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Aquí iría el formulario para crear o editar artesanías (demo).',
        ),
      ),
    );
  }
}
