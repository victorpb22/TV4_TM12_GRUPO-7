class Artesania {
  final String id;
  final String nombre;
  final String categoria;
  final double precio;

  Artesania({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
  });

  // Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'categoria': categoria, 'precio': precio};
  }

  // Para leer desde Firestore
  factory Artesania.fromMap(String id, Map<String, dynamic> data) {
    return Artesania(
      id: id,
      nombre: data['nombre'] ?? '',
      categoria: data['categoria'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
    );
  }
}
