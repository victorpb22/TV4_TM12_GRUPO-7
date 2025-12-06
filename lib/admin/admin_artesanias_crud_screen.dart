import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/artesania.dart';
import '../../services/firestore_service.dart';

class AdminArtesaniasCrudScreen extends StatefulWidget {
  static const String routeName = '/admin-artesanias-crud';

  const AdminArtesaniasCrudScreen({super.key});

  @override
  State<AdminArtesaniasCrudScreen> createState() =>
      _AdminArtesaniasCrudScreenState();
}

class _AdminArtesaniasCrudScreenState extends State<AdminArtesaniasCrudScreen> {
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Artesanías')),
      body: StreamBuilder<List<Artesania>>(
        stream: _firestoreService.escucharArtesanias(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar datos: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('No hay artesanías registradas'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final art = lista[index];
              return ListTile(
                title: Text(art.nombre),
                subtitle: Text(
                  '${art.categoria} • \$${art.precio.toStringAsFixed(2)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _mostrarDialogoEditar(art),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarEliminar(art),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoCrear,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ------------------------
  // CREATE
  // ------------------------
  Future<void> _mostrarDialogoCrear() async {
    final nombreCtrl = TextEditingController();
    final categoriaCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nueva artesanía'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: categoriaCtrl,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: precioCtrl,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreCtrl.text.trim();
                final categoria = categoriaCtrl.text.trim();
                final precio = double.tryParse(precioCtrl.text);

                if (nombre.isEmpty ||
                    categoria.isEmpty ||
                    precio == null ||
                    precio <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, completa todos los campos correctamente.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                try {
                  await _firestoreService.crearArtesania(
                    nombre: nombre,
                    categoria: categoria,
                    precio: precio,
                  );

                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Artesanía creada con éxito.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al crear: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------
  // UPDATE
  // ------------------------
  Future<void> _mostrarDialogoEditar(Artesania art) async {
    final nombreCtrl = TextEditingController(text: art.nombre);
    final categoriaCtrl = TextEditingController(text: art.categoria);
    final precioCtrl = TextEditingController(text: art.precio.toString());

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar artesanía'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: categoriaCtrl,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                TextField(
                  controller: precioCtrl,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreCtrl.text.trim();
                final categoria = categoriaCtrl.text.trim();
                final precio = double.tryParse(precioCtrl.text);

                if (nombre.isEmpty ||
                    categoria.isEmpty ||
                    precio == null ||
                    precio <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por favor, completa todos los campos correctamente.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final actualizado = Artesania(
                  id: art.id,
                  nombre: nombre,
                  categoria: categoria,
                  precio: precio,
                );

                try {
                  await _firestoreService.actualizarArtesania(actualizado);

                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Artesanía actualizada con éxito.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al actualizar: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------
  // DELETE
  // ------------------------
  Future<void> _confirmarEliminar(Artesania art) async {
    final resp = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Seguro que deseas eliminar "${art.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (resp == true) {
      try {
        await _firestoreService.eliminarArtesania(art.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${art.nombre}" fue eliminada.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
