class Publicacion {
  final String id;
  final String nombreTrabajador;
  final String categoria;
  final String titulo;
  final String descripcionCorta;
  final double rating;
  final int trabajosCompletados;
  final String fotoUrl;

  const Publicacion({
    required this.id,
    required this.nombreTrabajador,
    required this.categoria,
    required this.titulo,
    this.descripcionCorta = 'Servicio profesional garantizado.',
    this.rating = 0.0,
    this.trabajosCompletados = 0,
    this.fotoUrl = 'https://via.placeholder.com/150',
  });
}