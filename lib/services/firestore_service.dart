import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/artesania.dart';

class FirestoreService {
  final CollectionReference _artesaniasRef = FirebaseFirestore.instance
      .collection('artesanias');

  // CREATE
  Future<void> crearArtesania({
    required String nombre,
    required String categoria,
    required double precio,
  }) async {
    await _artesaniasRef.add({
      'nombre': nombre,
      'categoria': categoria,
      'precio': precio,
      'creadoEn': FieldValue.serverTimestamp(),
    });
  }

  // READ (Stream para listar en tiempo real)
  Stream<List<Artesania>> escucharArtesanias() {
    return _artesaniasRef.orderBy('nombre').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Artesania.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE
  Future<void> actualizarArtesania(Artesania art) async {
    await _artesaniasRef.doc(art.id).update(art.toMap());
  }

  // DELETE
  Future<void> eliminarArtesania(String id) async {
    await _artesaniasRef.doc(id).delete();
  }
}
