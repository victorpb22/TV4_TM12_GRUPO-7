import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
import 'admin/admin_clients_crud_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ArtesaniasApp());
}

class ArtesaniasApp extends StatelessWidget {
  const ArtesaniasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artesanias App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFEFFDF7F1),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        // ======= CLIENTE =======
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        LoginFormScreen.routeName: (_) => const LoginFormScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        AboutScreen.routeName: (_) => const AboutScreen(),
        ContactScreen.routeName: (_) => const ContactScreen(),
        BookingScreen.routeName: (_) => const BookingScreen(),
        ClientsRegisterScreen.routeName: (_) => const ClientsRegisterScreen(),
        ProductsListScreen.routeName: (_) => const ProductsListScreen(),

        // 🔽🔽🔽 AQUI VAN LAS RUTAS ADMIN
        AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
        AdminProductForm.routeName: (_) => const AdminProductForm(),
        '/admin-clients-crud': (_) => const AdminClientsCrudScreen(),
      },
    );
  }
}
