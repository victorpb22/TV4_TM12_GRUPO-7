import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiénes somos')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Somos un emprendimiento dedicado a la venta de artesanías '
            'hechas a mano por artesanos locales. Buscamos preservar la '
            'cultura y ofrecer productos únicos como pulseras, cerámicas, '
            'tejidos y más.',
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
