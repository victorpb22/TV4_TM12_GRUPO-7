import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'contact_screen.dart';
import 'booking_screen.dart';
import 'products_list_screen.dart';
import '../admin/admin_home_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = <_HomeOption>[
      _HomeOption(
        title: 'Quiénes somos',
        subtitle: 'Conoce nuestra historia y misión',
        icon: Icons.storefront,
        onTap: () => Navigator.pushNamed(context, AboutScreen.routeName),
      ),
      _HomeOption(
        title: 'Catálogo de artesanías',
        subtitle: 'Explora productos por categoría',
        icon: Icons.category,
        onTap: () => Navigator.pushNamed(context, ProductsListScreen.routeName),
      ),
      _HomeOption(
        title: 'Reserva / Pedido',
        subtitle: 'Solicita productos personalizados',
        icon: Icons.shopping_bag,
        onTap: () => Navigator.pushNamed(context, BookingScreen.routeName),
      ),
      _HomeOption(
        title: 'Contacto',
        subtitle: 'Escríbenos tus dudas o comentarios',
        icon: Icons.contact_mail,
        onTap: () => Navigator.pushNamed(context, ContactScreen.routeName),
      ),
      _HomeOption(
        title: 'Administrador',
        subtitle: 'Gestión de productos y clientes',
        icon: Icons.admin_panel_settings,
        onTap: () => Navigator.pushNamed(context, AdminHomeScreen.routeName),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artesanías App'),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = options[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
