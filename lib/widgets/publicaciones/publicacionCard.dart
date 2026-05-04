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
    return Card(
      elevation: 4.0, // Sombra suave para destacar
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap, // Permite que la tarjeta sea interactiva
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- 1. Header: Foto y Categoría ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(publicacion.fotoUrl),
                  backgroundColor: Colors.blueGrey,
                ),
                title: Text(
                  publicacion.nombreTrabajador,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  publicacion.categoria,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
              ),
              
              const Divider(height: 12.0),

              // --- 2. Título y Descripción del Servicio ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  publicacion.titulo,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                publicacion.descripcionCorta,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16.0),

              // --- 3. Footer: Rating y Trabajos Completados ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Rating (Estrellas)
                  _buildRating(publicacion.rating),
                  
                  // Trabajos Completados
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${publicacion.trabajosCompletados}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Trabajos Completados',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
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
