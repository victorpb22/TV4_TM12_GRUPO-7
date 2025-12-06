import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiénes somos'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto de presentación
            const Text(
              'Artesanías App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Somos una comunidad de artesanos que elabora productos hechos a mano '
              'con materiales locales. Cada pieza está creada con dedicación, '
              'cariño y respeto por nuestras tradiciones.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Tarjeta Misión
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Misión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ofrecer artesanías de calidad que transmitan historia, '
                      'identidad y calidez, conectando a nuestros artesanos con '
                      'clientes que valoran lo auténtico y lo hecho a mano.',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta Visión
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Visión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ser una marca reconocida a nivel nacional por rescatar '
                      'tradiciones artesanales, impulsar la economía local y '
                      'promover un consumo responsable y sostenible.',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Nuestro trabajo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Galería simple de imágenes
            Row(
              children: const [
                _GalleryImage(path: 'assets/images/bisuteria_artesania.jpg'),
                SizedBox(width: 2),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ejemplos de nuestras piezas artesanales. Cada producto es único '
              'y puede variar en colores, formas y diseños.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  final String path;

  const _GalleryImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(path, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
