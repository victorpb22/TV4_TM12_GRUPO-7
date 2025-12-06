import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'products_list_screen.dart';
import 'booking_screen.dart';
import 'contact_screen.dart';
import '../admin/admin_home_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  /// Si es true, solo se muestran Quiénes somos y Catálogo.
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    // Todas las opciones disponibles
    final allOptions = <_HomeOption>[
      _HomeOption(
        icon: Icons.storefront_outlined,
        title: 'Quiénes somos',
        subtitle: 'Conoce nuestra historia y misión',
        onTap: () => Navigator.pushNamed(context, AboutScreen.routeName),
      ),
      _HomeOption(
        icon: Icons.category_outlined,
        title: 'Catálogo de artesanías',
        subtitle: 'Explora productos por categoría',
        onTap: () => Navigator.pushNamed(context, ProductsListScreen.routeName),
      ),
      _HomeOption(
        icon: Icons.shopping_bag_outlined,
        title: 'Reserva / Pedido',
        subtitle: 'Solicita productos personalizados',
        onTap: () => Navigator.pushNamed(context, BookingScreen.routeName),
      ),
      _HomeOption(
        icon: Icons.mail_outline,
        title: 'Contacto',
        subtitle: 'Escríbenos tus dudas o comentarios',
        onTap: () => Navigator.pushNamed(context, ContactScreen.routeName),
      ),
      _HomeOption(
        icon: Icons.admin_panel_settings_outlined,
        title: 'Administrador',
        subtitle: 'Gestión de productos y clientes',
        onTap: () => Navigator.pushNamed(context, AdminHomeScreen.routeName),
      ),
    ];

    // Si es invitado, solo mostramos las dos primeras opciones
    final options = isGuest ? allOptions.take(2).toList() : allOptions;

    return Scaffold(
      appBar: AppBar(title: const Text('Artesanías App'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = options[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: item.onTap,
            ),
          );
        },
      ),
    );
  }
}

class _HomeOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _HomeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
