import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_app/entities/solicitudes.dart';

class TrabajadorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenemos solicitudes 'pendientes' que coincidan con las categorías del trabajador
  Stream<List<Solicitud>> getSolicitudesDisponibles(List<String> categoriasInteres) {
    return _firestore
        .collection('solicitudes')
        .where('status', isEqualTo: 'pendiente')
        .where('categoria', whereIn: categoriasInteres) // Filtro por especialidad
        // .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Solicitud.fromFirestore(doc)).toList());
  }
}