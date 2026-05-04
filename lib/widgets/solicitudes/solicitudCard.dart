import 'package:flutter/material.dart';
import 'package:push_app/entities/solicitudes.dart';




class SolicitudCard extends StatelessWidget {
  final Solicitud solicitud;
  final VoidCallback? onTap;

  const SolicitudCard({
    super.key,
    required this.solicitud,
    this.onTap,
  });

  // --- Helpers para el estado ---

  Color _getStatusColor(BuildContext context, SolicitudStatus status) {
    switch (status) {
      case SolicitudStatus.pendiente:
        return Colors.orange.shade600;
      case SolicitudStatus.activa:
        return Theme.of(context).colorScheme.primary; // Color principal de la app
      case SolicitudStatus.completada:
        return Colors.green.shade600;
      case SolicitudStatus.cancelada:
        return Colors.red.shade400;
    }
  }

  IconData _getStatusIcon(SolicitudStatus status) {
    switch (status) {
      case SolicitudStatus.pendiente:
        return Icons.hourglass_empty;
      case SolicitudStatus.activa:
        return Icons.construction;
      case SolicitudStatus.completada:
        return Icons.task_alt;
      case SolicitudStatus.cancelada:
        return Icons.close_sharp;
    }
  }

  // --- Widget Principal ---

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context, solicitud.status);
    
    // Formatear la fecha para una mejor visualización
    final formattedDate = 
        '${solicitud.fechaCreacion.day}/${solicitud.fechaCreacion.month}/${solicitud.fechaCreacion.year}';

    return Card(    
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1.0), // Borde suave basado en el estado
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 1. Icono de Estado
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  _getStatusIcon(solicitud.status), 
                  color: statusColor, 
                  size: 32.0,
                ),
              ),
              
              const SizedBox(width: 16.0),

              // 2. Contenido Central (Título y Subtítulos)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      solicitud.titulo,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Categoría: ${solicitud.categoria}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    // Mostrar el trabajador solo si ya está asignado
                    if (solicitud.status != SolicitudStatus.pendiente)
                      Text(
                        'Trabajador: ${solicitud.trabajadorId ?? 'No asignado'}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    
                    const SizedBox(height: 8.0),
                    
                    // Fecha de Creación
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 4.0),
                        Text(
                          'Creada: $formattedDate',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Etiqueta de Estado y Botón de Acción
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Etiqueta de Estado (Chip)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      solicitud.status.name.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Botón de Acción (Condicional)
                  _buildActionButton(context, solicitud.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir el botón de acción según el estado
  Widget _buildActionButton(BuildContext context, SolicitudStatus status) {
    String text = '';
    VoidCallback action = () {};
    Color color = Theme.of(context).colorScheme.primary;

    switch (status) {
      case SolicitudStatus.pendiente:
        text = 'VER OFERTAS';
        color = Colors.orange;
        // La acción onTap es la principal, pero se puede añadir una específica aquí
        action = onTap ?? () {}; 
        break;
      case SolicitudStatus.activa:
        text = 'CHATEAR';
        color = Theme.of(context).colorScheme.secondary;
        // La acción real debe ir al chat con el trabajador asignado
        action = () { /* context.go('/chat/${solicitud.trabajadorUid}'); */ };
        break;
      case SolicitudStatus.completada:
        text = 'EVALUAR';
        color = Colors.green;
        // La acción real debe ir a la pantalla de evaluación/rating
        action = () { /* context.go('/evaluacion/${solicitud.id}'); */ };
        break;
      case SolicitudStatus.cancelada:
        return const SizedBox.shrink(); // No hay acción para canceladas
    }

    return TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.all(0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}