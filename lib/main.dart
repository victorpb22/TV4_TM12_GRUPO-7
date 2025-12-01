import 'package:flutter/material.dart';

// Screens cliente
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/login_form_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/clients_register_screen.dart';
import 'screens/products_list_screen.dart';

// Screens admin
import 'admin/admin_home_screen.dart';
import 'admin/admin_product_form.dart';
import 'admin/admin_clients_screen.dart';

void main() {
  runApp(const ArtesaniasApp());
}

class ArtesaniasApp extends StatelessWidget {
  const ArtesaniasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artesanías App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFDF7F1),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        LoginFormScreen.routeName: (_) => const LoginFormScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        AboutScreen.routeName: (_) => const AboutScreen(),
        ContactScreen.routeName: (_) => const ContactScreen(),
        BookingScreen.routeName: (_) => const BookingScreen(),
        ClientsRegisterScreen.routeName: (_) => const ClientsRegisterScreen(),
        ProductsListScreen.routeName: (_) => const ProductsListScreen(),
        AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
        AdminProductForm.routeName: (_) => const AdminProductForm(),
        AdminClientsScreen.routeName: (_) => const AdminClientsScreen(),
      },
    );
  }
}
