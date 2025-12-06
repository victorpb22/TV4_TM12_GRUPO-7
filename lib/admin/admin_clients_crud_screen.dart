import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminClientsCrudScreen extends StatefulWidget {
  const AdminClientsCrudScreen({super.key});

  @override
  State<AdminClientsCrudScreen> createState() => _AdminClientsCrudScreenState();
}

class _AdminClientsCrudScreenState extends State<AdminClientsCrudScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers del formulario
  final _cedulaCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();

  // Para saber si estamos editando un cliente existente
  bool _isEditing = false;
  String? _currentDocId; // normalmente será la misma cédula

  // Filtro por fecha de registro (consulta masiva)
  DateTime? _filterDate;

  final CollectionReference _clientesRef = FirebaseFirestore.instance
      .collection('clientes');

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  // ------------------------- CRUD MÉTODOS -------------------------

  /// Buscar cliente por cédula
  Future<void> _buscarPorCedula() async {
    final cedula = _cedulaCtrl.text.trim();
    if (cedula.isEmpty) {
      _showSnack('Ingrese una cédula para buscar');
      return;
    }

    try {
      final doc = await _clientesRef.doc(cedula).get();

      if (!doc.exists) {
        // No existe: limpiamos otros campos y dejamos listo para crear
        _nombreCtrl.clear();
        _emailCtrl.clear();
        _telefonoCtrl.clear();
        setState(() {
          _isEditing = false;
          _currentDocId = null;
        });
        _showSnack('No se encontró cliente. Puede crearlo con estos datos.');
        return;
      }

      final data = doc.data() as Map<String, dynamic>;
      _nombreCtrl.text = data['nombre'] ?? '';
      _emailCtrl.text = data['email'] ?? '';
      _telefonoCtrl.text = data['telefono'] ?? '';

      setState(() {
        _isEditing = true;
        _currentDocId = doc.id;
      });

      _showSnack('Cliente encontrado y cargado en el formulario');
    } catch (e) {
      _showSnack('Error al buscar: $e');
    }
  }

  /// Crear o actualizar cliente
  Future<void> _guardarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    final cedula = _cedulaCtrl.text.trim();
    final nombre = _nombreCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final telefono = _telefonoCtrl.text.trim();

    final data = <String, dynamic>{
      'cedula': cedula,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      // Para nuevos registros, guardamos fechaRegistro; para update, la dejamos igual
      'fechaActualizacion': FieldValue.serverTimestamp(),
    };

    try {
      if (_isEditing && _currentDocId != null) {
        // ACTUALIZAR
        await _clientesRef.doc(_currentDocId).update(data);
        _showSnack('Cliente actualizado correctamente');
      } else {
        // CREAR (usamos la cédula como ID del documento)
        await _clientesRef.doc(cedula).set({
          ...data,
          'fechaRegistro': FieldValue.serverTimestamp(),
        });
        setState(() {
          _isEditing = true;
          _currentDocId = cedula;
        });
        _showSnack('Cliente creado correctamente');
      }
    } catch (e) {
      _showSnack('Error al guardar: $e');
    }
  }

  /// Eliminar cliente actual
  Future<void> _eliminarCliente() async {
    if (_currentDocId == null) {
      _showSnack('Busque primero un cliente para poder eliminarlo');
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: const Text('¿Seguro que desea eliminar este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _clientesRef.doc(_currentDocId).delete();
      _cedulaCtrl.clear();
      _nombreCtrl.clear();
      _emailCtrl.clear();
      _telefonoCtrl.clear();

      setState(() {
        _isEditing = false;
        _currentDocId = null;
      });

      _showSnack('Cliente eliminado correctamente');
    } catch (e) {
      _showSnack('Error al eliminar: $e');
    }
  }

  /// Elegir fecha para filtrar listado
  Future<void> _pickFilterDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _filterDate = picked;
      });
    }
  }

  void _clearFilterDate() {
    setState(() {
      _filterDate = null;
    });
  }

  // ------------------------- UI -------------------------

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // Construimos consulta para el listado masivo
    Query clientesQuery = _clientesRef.orderBy(
      'fechaRegistro',
      descending: true,
    );

    if (_filterDate != null) {
      final start = DateTime(
        _filterDate!.year,
        _filterDate!.month,
        _filterDate!.day,
      );
      final end = start.add(const Duration(days: 1));

      clientesQuery = clientesQuery
          .where(
            'fechaRegistro',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
          )
          .where('fechaRegistro', isLessThan: Timestamp.fromDate(end));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de clientes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ---------- FORMULARIO ----------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulario de cliente',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),

                  // CÉDULA
                  TextFormField(
                    controller: _cedulaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Cédula',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _buscarPorCedula,
                        tooltip: 'Buscar por cédula',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Ingrese la cédula';
                      if (v.length < 10) {
                        return 'La cédula debe tener al menos 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // NOMBRE
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Ingrese el nombre';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // EMAIL
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Ingrese el email';
                      if (!v.contains('@')) return 'Email no válido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // TELÉFONO
                  TextFormField(
                    controller: _telefonoCtrl,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _guardarCliente,
                        icon: const Icon(Icons.save),
                        label: Text(_isEditing ? 'Actualizar' : 'Crear'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _eliminarCliente,
                        icon: const Icon(Icons.delete),
                        label: const Text('Eliminar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // ---------- FILTRO POR FECHA ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Consulta por fecha:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _pickFilterDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _filterDate == null
                        ? 'Todas las fechas'
                        : '${_filterDate!.day.toString().padLeft(2, '0')}/'
                              '${_filterDate!.month.toString().padLeft(2, '0')}/'
                              '${_filterDate!.year}',
                  ),
                ),
                if (_filterDate != null)
                  IconButton(
                    onPressed: _clearFilterDate,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Quitar filtro',
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ---------- LISTADO DE CLIENTES ----------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: clientesQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar clientes: ${snapshot.error}'),
                  );
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay clientes registrados para este filtro.',
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final cedula = data['cedula'] ?? docs[index].id;
                    final nombre = data['nombre'] ?? '';
                    final email = data['email'] ?? '';
                    final telefono = data['telefono'] ?? '';
                    final fecha = data['fechaRegistro'] as Timestamp?;
                    final fechaStr = fecha == null
                        ? '-'
                        : '${fecha.toDate().day.toString().padLeft(2, '0')}/'
                              '${fecha.toDate().month.toString().padLeft(2, '0')}/'
                              '${fecha.toDate().year}';

                    return ListTile(
                      title: Text('$nombre ($cedula)'),
                      subtitle: Text(
                        'Email: $email\nTeléfono: $telefono\nRegistrado: $fechaStr',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        // Al tocar un elemento lo cargamos en el formulario para editar
                        _cedulaCtrl.text = cedula;
                        _nombreCtrl.text = nombre;
                        _emailCtrl.text = email;
                        _telefonoCtrl.text = telefono;
                        setState(() {
                          _isEditing = true;
                          _currentDocId = docs[index].id;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
