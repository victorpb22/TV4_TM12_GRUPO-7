import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';

class ClientsService {
  final _ref = FirebaseFirestore.instance.collection('clientes');

  Future<void> crearCliente({
    required String nombre,
    required String cedula,
    required String email,
    required String telefono,
  }) async {
    final nuevo = ClientModel(
      id: '',
      nombre: nombre,
      cedula: cedula,
      email: email,
      telefono: telefono,
      fechaRegistro: DateTime.now(),
    );
    await _ref.add(nuevo.toMap());
  }

  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    required String cedula,
    required String email,
    required String telefono,
  }) async {
    await _ref.doc(id).update({
      'nombre': nombre,
      'cedula': cedula,
      'email': email,
      'telefono': telefono,
    });
  }

  Future<ClientModel?> buscarPorCedula(String cedula) async {
    final query = await _ref.where('cedula', isEqualTo: cedula).limit(1).get();
    if (query.docs.isEmpty) return null;
    return ClientModel.fromDoc(query.docs.first);
  }

  Future<void> eliminarCliente(String id) async {
    await _ref.doc(id).delete();
  }

  /// Consulta masiva, filtrando opcionalmente por fecha (solo día)
  Stream<List<ClientModel>> streamClientes({DateTime? fechaFiltro}) {
    Query<Map<String, dynamic>> query = _ref;

    if (fechaFiltro != null) {
      final inicio = DateTime(
        fechaFiltro.year,
        fechaFiltro.month,
        fechaFiltro.day,
      );
      final fin = inicio.add(const Duration(days: 1));

      query = query
          .where(
            'fechaRegistro',
            isGreaterThanOrEqualTo: Timestamp.fromDate(inicio),
          )
          .where('fechaRegistro', isLessThan: Timestamp.fromDate(fin));
    }

    query = query.orderBy('fechaRegistro', descending: true);

    return query.snapshots().map(
      (snap) => snap.docs.map((d) => ClientModel.fromDoc(d)).toList(),
    );
  }
}
