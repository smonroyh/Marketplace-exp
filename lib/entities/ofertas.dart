class Oferta {
  final String id;
  final String trabajadorId;
  final String nombreTrabajador;
  final double monto;
  final String mensaje;
  final double ratingTrabajador;
  final DateTime fechaCreacion;
  final String? fotoTrabajadorUrl;

  Oferta({
    required this.id,
    required this.trabajadorId,
    required this.nombreTrabajador,
    required this.monto,
    required this.mensaje,
    required this.ratingTrabajador,
    required this.fechaCreacion,
    required this.fotoTrabajadorUrl,
  });

  factory Oferta.fromMap(Map<String, dynamic> map) {
    return Oferta(
      id: map['id'] ?? '',
      trabajadorId: map['trabajadorId'] ?? '',
      nombreTrabajador: map['nombreTrabajador'] ?? '',
      monto: (map['monto'] as num?)?.toDouble() ?? 0.0,
      mensaje: map['mensaje'] ?? '',
      ratingTrabajador: (map['ratingTrabajador'] as num?)?.toDouble() ?? 0.0,
      fechaCreacion: map['fechaCreacion'] is DateTime
          ? map['fechaCreacion']
          : DateTime.now(),
      fotoTrabajadorUrl: map['fotoTrabajadorUrl'],
    );
  }
}