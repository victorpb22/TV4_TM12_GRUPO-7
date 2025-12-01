import 'package:flutter/material.dart';

class ClientsRegisterScreen extends StatelessWidget {
  static const String routeName = '/clients-register';

  const ClientsRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // solo demo, igual que registro pero como sección aparte
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes registrados (demo)')),
      body: const Center(
        child: Text('Aquí se mostraría la lista o formulario de clientes.'),
      ),
    );
  }
}
