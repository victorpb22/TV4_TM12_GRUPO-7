import 'package:flutter/material.dart';

class ProductsListScreen extends StatelessWidget {
  static const String routeName = '/products';

  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = {
      'Tejidos': ['Poncho artesanal', 'Bufanda de lana'],
      'Cerámica': ['Jarrón pintado a mano', 'Taza decorativa'],
      'Bisutería': ['Pulsera de piedras', 'Collar tejido'],
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de artesanías')),
      body: ListView(
        children: categorias.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key),
            children: entry.value
                .map(
                  (producto) => ListTile(
                    title: Text(producto),
                    subtitle: const Text('Ver detalles (demo)'),
                  ),
                )
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}
