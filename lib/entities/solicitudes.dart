import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_app/entities/ofertas.dart';

enum SolicitudStatus {
  pendiente, // Esperando que un trabajador acepte/responda
  activa,    // Un trabajador ha aceptado y el trabajo está en curso
  completada, // Trabajo finalizado y evaluado
  cancelada, // Cancelada por el cliente o el trabajador
}

class Solicitud {
  final String id;
  final String clienteId;
  final String titulo;
  final String detalles;
  final SolicitudStatus status;
  final String? trabajadorId;
  final double? presupuesto;

  //Datos desnormalizados del trabajador asignado
  final String? fotoTrabajadorUrl;
  final String? nombreTrabajador;
  final double? ratingTrabajador;


  final String categoria;
  final DateTime fechaCreacion;


  //Crear sub-colección de ofertas recibidas
  final List<Oferta>? ofertas; 
  // final String ubicacion; 

  const Solicitud( {
    required this.id,
    required this.clienteId,
    required this.titulo,
    required this.detalles,
    required this.status,
    required this.presupuesto,
    this.trabajadorId,
    this.fotoTrabajadorUrl, 
    this.nombreTrabajador, 
    this.ratingTrabajador,
    required this.categoria,
    required this.fechaCreacion,
    this.ofertas,
  });

  factory Solicitud.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Solicitud(
      id: doc.id,
      clienteId: data['clienteId'] ?? '',
      titulo: data['titulo'] ?? '',
      presupuesto: data['presupuesto'] != null ? (data['presupuesto'] as num).toDouble() : 0.0,
      detalles: data['detalles'] ?? '',
      status: _statusFromString(data['status'] ?? 'pendiente'),
      trabajadorId: data['trabajadorId'],
      fotoTrabajadorUrl: data['fotoTrabajadorUrl'],
      nombreTrabajador: data['nombreTrabajador'],
      ratingTrabajador: (data['ratingTrabajador'] as num?)?.toDouble(),
      categoria: data['categoria'] ?? '',
      fechaCreacion: (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ofertas: data['ofertas'] != null
          ? (data['ofertas'] as List).map((o) => Oferta.fromMap(o)).toList()
          : null,
    );
  }

  static SolicitudStatus _statusFromString(String status) {
    switch (status) {
      case 'activa':
        return SolicitudStatus.activa;
      case 'completada':
        return SolicitudStatus.completada;
      case 'cancelada':
        return SolicitudStatus.cancelada;
      case 'pendiente':
      default:
        return SolicitudStatus.pendiente;
    }
  }

  copywith({
    String? id,
    String? clienteId,
    String? detalles,
    String? titulo,
    SolicitudStatus? status,
    String? trabajadorId,
    double? presupuesto,
    String? categoria,
    DateTime? fechaCreacion,
    List<Oferta>? ofertas,
    String? fotoTrabajadorUrl,
    String? nombreTrabajador,
    double? ratingTrabajador,
  }) {
    return Solicitud(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      titulo: titulo ?? this.titulo,
      detalles: detalles ?? this.detalles,
      status: status ?? this.status,
      trabajadorId: trabajadorId ?? this.trabajadorId,
      presupuesto: presupuesto ?? this.presupuesto,
      categoria: categoria ?? this.categoria,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ofertas: ofertas ?? this.ofertas,
      fotoTrabajadorUrl: fotoTrabajadorUrl ?? this.fotoTrabajadorUrl,
      nombreTrabajador: nombreTrabajador ?? this.nombreTrabajador,
      ratingTrabajador: ratingTrabajador ?? this.ratingTrabajador,
    );
  }
}