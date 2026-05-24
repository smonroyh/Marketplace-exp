import 'package:flutter/material.dart';
import 'package:push_app/entities/publicaciones.dart';

class PublicacionCard extends StatelessWidget {
  final Publicacion publicacion;
  final VoidCallback? onTap;

  const PublicacionCard({
    super.key,
    required this.publicacion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // --- Left: Worker Image ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  publicacion.fotoUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFF4F4F5),
                    child: const Icon(Icons.person, color: Color(0xFF71717A)),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // --- Right: Info Column ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Name & Rating Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            publicacion.nombreTrabajador,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF09090B),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFF59E0B), size: 12),
                              const SizedBox(width: 4),
                              Text(
                                publicacion.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF09090B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),

                    // Title / Category
                    Text(
                      publicacion.titulo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF71717A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),

                    // Stats row: Distance & Completed reviews
                    Row(
                      children: [
                        const Text(
                          '1.2 km', // Mock distance
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF71717A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFFE4E4E7),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${publicacion.trabajosCompletados} trabajos',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF71717A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRating(double rating) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4.0),
        Text(
          rating.toStringAsFixed(1), // Muestra una cifra decimal
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '(${rating >= 4.0 ? 'Excelente' : 'Buen Servicio'})',
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      ],
    );
  }
