import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String id;
  final String nombre;
  final String cedula;
  final String email;
  final String telefono;
  final DateTime fechaRegistro;

  ClientModel({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.email,
    required this.telefono,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cedula': cedula,
      'email': email,
      'telefono': telefono,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  factory ClientModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ClientModel(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      cedula: data['cedula'] ?? '',
      email: data['email'] ?? '',
      telefono: data['telefono'] ?? '',
      fechaRegistro:
          (data['fechaRegistro'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
