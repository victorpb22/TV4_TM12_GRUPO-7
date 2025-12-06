import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminClientsScreen extends StatefulWidget {
  static const String routeName = '/admin-clients';

  const AdminClientsScreen({super.key});

  @override
  State<AdminClientsScreen> createState() => _AdminClientsScreenState();
}

class _AdminClientsScreenState extends State<AdminClientsScreen> {
  final TextEditingController _cedulaCtrl = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() {
    _cedulaCtrl.dispose();
    super.dispose();
  }

  // ==========================
  //  SELECTORES DE FECHA
  // ==========================

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _fromDate = picked);
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _toDate = picked);
    }
  }

  // ==========================
  //  CONSTRUCCIÓN DE LA QUERY
  // ==========================

  Query _buildQuery() {
    final col = FirebaseFirestore.instance.collection('clientes');

    final cedula = _cedulaCtrl.text.trim();

    // 1) CONSULTA ESPECÍFICA POR CÉDULA
    if (cedula.isNotEmpty) {
      // Busca el (los) cliente(s) con esa cédula
      return col.where('cedula', isEqualTo: cedula);
    }

    // 2) CONSULTA MASIVA FILTRADA POR FECHA
    Query q = col.orderBy('fechaRegistro', descending: true);

    if (_fromDate != null) {
      final start = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
      q = q.where(
        'fechaRegistro',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start),
      );
    }

    if (_toDate != null) {
      final end = DateTime(
        _toDate!.year,
        _toDate!.month,
        _toDate!.day,
        23,
        59,
        59,
      );
      q = q.where(
        'fechaRegistro',
        isLessThanOrEqualTo: Timestamp.fromDate(end),
      );
    }

    return q;
  }

  // ==========================
  //  UI
  // ==========================

  @override
  Widget build(BuildContext context) {
    final query = _buildQuery();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes registrados'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --------- FILTROS ---------
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BUSCAR POR CÉDULA
                TextField(
                  controller: _cedulaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Buscar por cédula',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _cedulaCtrl.clear();
                        setState(() {}); // actualiza la query
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {}); // cada cambio actualiza la query
                  },
                ),
                const SizedBox(height: 12),

                // RANGO DE FECHAS (solo se usa si la cédula está vacía)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromDate,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _fromDate == null
                              ? 'Desde'
                              : 'Desde: ${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickToDate,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _toDate == null
                              ? 'Hasta'
                              : 'Hasta: ${_toDate!.day}/${_toDate!.month}/${_toDate!.year}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '👉 Si escribes una cédula, el filtro por fecha se ignora\n'
                  '👉 Si la cédula está vacía, se muestran todos los clientes filtrados por fecha',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(height: 0),

          // --------- LISTA DE RESULTADOS ---------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
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
                    child: Text('No se encontraron clientes'),
                  );
                }

                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final nombre = data['nombre'] ?? '';
                    final cedula = data['cedula'] ?? '';
                    final email = data['email'] ?? '';
                    final ts = data['fechaRegistro'] as Timestamp?;
                    final fecha = ts?.toDate();

                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cédula: $cedula'),
                          Text('Email: $email'),
                          if (fecha != null)
                            Text(
                              'Registrado: ${fecha.day}/${fecha.month}/${fecha.year} '
                              '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
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
