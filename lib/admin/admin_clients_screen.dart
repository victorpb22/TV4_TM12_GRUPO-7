import 'package:flutter/material.dart';

class AdminClientsScreen extends StatelessWidget {
  static const String routeName = '/admin-clients';

  const AdminClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clients = ['Juan Pérez', 'María García', 'Carlos López'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes registrados'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: clients.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(clients[index]),
            subtitle: const Text('Cliente de artesanías (demo)'),
          );
        },
      ),
    );
  }
}
