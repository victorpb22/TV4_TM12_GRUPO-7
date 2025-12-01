import 'package:flutter/material.dart';
import 'admin_product_form.dart';
import 'admin_clients_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  static const String routeName = '/admin';

  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('Crear / editar productos'),
            subtitle: const Text('Agregar o modificar artesanías'),
            onTap: () {
              Navigator.pushNamed(context, AdminProductForm.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes registrados'),
            subtitle: const Text('Ver y gestionar clientes'),
            onTap: () {
              Navigator.pushNamed(context, AdminClientsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
