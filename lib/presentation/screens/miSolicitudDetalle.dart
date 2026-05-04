import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Asume que tienes estos imports
// import 'package:your_app/blocs/solicitudes/solicitudes_bloc.dart';
// import 'package:your_app/blocs/solicitudes/solicitudes_state.dart';
// import 'package:your_app/models/solicitud.dart'; 
// import 'package:your_app/models/solicitud_status.dart'; 
import 'package:formz/formz.dart';
import 'package:push_app/entities/ofertas.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/cubit/solicitud_detalle_cubit.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart'; // Para el estado de carga





class SolicitudDetailScreen extends StatelessWidget {
  final Solicitud solicitud;
  final SolicitudesBloc solicitudesBloc;

  const SolicitudDetailScreen({
    super.key, 
    required this.solicitud,
    required this.solicitudesBloc,
  });

  @override
  Widget build(BuildContext context) {

    // 1. Iniciar el BLoC para la carga del detalle
    return BlocProvider(
      create: (context) => 
      SolicitudDetalleCubit(
        solicitudId: solicitud.id,
        solicitudesBloc: solicitudesBloc,
      )..loadSolicitudDetail(solicitud.id),
      child: Scaffold(
        appBar: AppBar( 
          title: const Text('Detalle de Solicitud'),
        ),
        body: BlocBuilder<SolicitudDetalleCubit, SolicitudDetalleState>(
          builder: (context, state) {
            if (state is SolicitudDetalleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SolicitudDetalleError) {
              return Center(child: Text('Error al cargar: ${state.message}'));
            }


            late final Solicitud solicitud;
            if (state is SolicitudDetalleLoaded ) {
              solicitud = state.solicitud;
            }
            // 2. Renderizar el contenido usando la data
            return _SolicitudDetailContent(solicitud: solicitud);
          },
        ),
      ),
    );
  }
}

class _SolicitudDetailContent extends StatelessWidget {
  final Solicitud solicitud;

  const _SolicitudDetailContent({required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Header y Estado ---
          _buildStatusHeader(context, solicitud),
          const SizedBox(height: 20),

          // --- 2. Información General ---
          _buildInfoSection(
            context,
            'Detalles del Trabajo',
            [
              _InfoRow(icon: Icons.category, label: 'Categoría', value: solicitud.categoria),
              // _InfoRow(icon: Icons.location_on, label: 'Ubicación', value: solicitud.ubicacion),
              _InfoRow(icon: Icons.calendar_today, label: 'Creada el', value: '${solicitud.fechaCreacion.day}/${solicitud.fechaCreacion.month}/${solicitud.fechaCreacion.year}'),
            ],
          ),
          const SizedBox(height: 20),

          // --- 3. Descripción Completa ---
          Text(
            'Descripción Completa',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            solicitud.detalles,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 30),

          // --- 4. Sección Dinámica de Gestión (Ofertas/Trabajador Asignado) ---
          _buildDynamicSection(context, solicitud),
          const SizedBox(height: 50),
          
          // --- 5. Acciones de Gestión ---
          _buildManagementActions(solicitud.id,context, solicitud.status),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, Solicitud solicitud) {
    final color = _getStatusColor(context, solicitud.status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          solicitud.titulo,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ESTADO: ${solicitud.status.name.toUpperCase()}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
  
  // Widget auxiliar para las filas de información
  Widget _buildInfoSection(BuildContext context, String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...rows
      ],
    );
  }

  // Lógica de Renderizado Dinámico
  Widget _buildDynamicSection(BuildContext context, Solicitud solicitud) {
    switch (solicitud.status) {
      case SolicitudStatus.pendiente:
        return _buildOfertasSection(context, solicitud.ofertas ?? []);
      case SolicitudStatus.activa:
        return _buildTrabajadorAsignadoSection(context, solicitud );
      case SolicitudStatus.completada:
        return _buildFinalizadoSection(context, 'Aún no evaluado. Presiona "Evaluar" abajo.');
      case SolicitudStatus.cancelada:
        return _buildInfoSection(context, 'Motivo de Cancelación', [
          const Text('Esta solicitud fue cancelada. No hay acciones adicionales disponibles.', style: TextStyle(color: Colors.red)),
        ]);
    }
  }
  
  Widget _buildOfertasSection(BuildContext context, List<Oferta> ofertas) {
    return _buildInfoSection(
      context,
      'Ofertas Recibidas (${ofertas.length})',
      ofertas.isEmpty
          ? [const Text('Aún no hay ofertas de trabajadores. Sé paciente.')]
          :ofertas.map((oferta) => _OfferCard(oferta: oferta,onAceptar: (){
            context.read<SolicitudDetalleCubit>().solicitudOfferedAccepted(solicitud.id, oferta);
            context.read<SolicitudesBloc>().add(UpdateSolicitud(solicitud: solicitud.copywith(
              status: SolicitudStatus.activa,
              trabajadorId: oferta.trabajadorId,
              fotoTrabajadorUrl: oferta.fotoTrabajadorUrl,
              nombreTrabajador: oferta.nombreTrabajador,
              ratingTrabajador: oferta.ratingTrabajador,
            ) ));
          },)).toList(),
    );
  }
  

  Widget _buildTrabajadorAsignadoSection(BuildContext context, Solicitud solicitud) {
    return _buildInfoSection(
      context,
      'Trabajador Asignado',
      [
        _OfferCard(solicitud: solicitud, onAceptar: (){})
        // ListTile(
        //   leading: const CircleAvatar(child: Icon(Icons.handyman)),
        //   title: Text(nombreTrabajador, style: const TextStyle(fontWeight: FontWeight.bold)),
        //   subtitle: const Text('Rating: 4.8 (Ver Perfil)'),
        //   trailing: IconButton(
        //     icon: const Icon(Icons.chat, color: Colors.green),
        //     onPressed: () {
        //       // Acción: Abrir Chat
        //     },
        //     tooltip: 'Abrir Chat',
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFinalizadoSection(BuildContext context, String evaluationStatus) {
    return _buildInfoSection(
      context,
      'Finalizado',
      [
        _InfoRow(icon: Icons.star, label: 'Estado de Evaluación', value: evaluationStatus),
      ],
    );
  }

  // --- Widgets de Acciones ---
  Widget _buildManagementActions(String id, BuildContext context, SolicitudStatus status) {
    final bloc = context.read<SolicitudDetalleCubit>(); // Para enviar eventos

    if (status == SolicitudStatus.pendiente) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.cancel),
        label: const Text('CANCELAR SOLICITUD'),
        onPressed: () {
          // Lógica para confirmar y enviar SolicitudCancelled Evento
          bloc.changeStatusSolicitud(id, SolicitudStatus.cancelada);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, minimumSize: const Size(double.infinity, 50)),
      );
    }
    
    if (status == SolicitudStatus.activa) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.check_circle),
        label: const Text('CONFIRMAR TRABAJO FINALIZADO'),
        onPressed: () {
          // Lógica para enviar SolicitudConfirmCompletion Evento
          bloc.changeStatusSolicitud(id, SolicitudStatus.completada);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
      );
    }
    
    if (status == SolicitudStatus.completada) {
      return OutlinedButton.icon(
        icon: const Icon(Icons.rate_review),
        label: const Text('EVALUAR TRABAJADOR'),
        onPressed: () {
          // Lógica para navegar a la pantalla de evaluación
        },
        style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
      );
    }

    return const SizedBox.shrink(); // No hay acciones para el resto
  }
  
  // Helpers de Estilo
  Color _getStatusColor(BuildContext context, SolicitudStatus status) {
    switch (status) {
      case SolicitudStatus.pendiente: return Colors.orange.shade600;
      case SolicitudStatus.activa: return Theme.of(context).colorScheme.primary;
      case SolicitudStatus.completada: return Colors.green.shade600;
      case SolicitudStatus.cancelada: return Colors.red.shade400;
    }
  }
}

class _OfferCard extends StatelessWidget {
  final Oferta? oferta;
  final Solicitud? solicitud;
  final VoidCallback onAceptar;

  const _OfferCard({
    super.key,
    this.oferta,
    this.solicitud,
    required this.onAceptar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/previews/014/194/232/non_2x/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg"),
                ),
                // CircleAvatar(
                //   radius: 25,
                //   backgroundImage: oferta.fotoUrl.isNotEmpty 
                //       ? NetworkImage(oferta.fotoUrl) 
                //       : null,
                //   child: oferta.fotoUrl.isEmpty ? const Icon(Icons.person) : null,
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oferta != null ? oferta!.nombreTrabajador : solicitud!.nombreTrabajador!,
                        // oferta.nombreTrabajador,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          oferta != null 
                            ? Text(" ${oferta!.ratingTrabajador} • Profesional")
                            : Text(" ${solicitud!.ratingTrabajador} • Profesional"),
                          
                        ],
                      ),
                    ],
                  ),
                ),

                oferta != null 
                ?
                Text(
                  "\$${oferta!.monto.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                oferta != null ? oferta!.mensaje : solicitud!.detalles,
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () { /* Ver Perfil Completo */ },
                  child: const Text("VER PERFIL"),
                ),
                
                oferta != null ?
                ElevatedButton(
                  onPressed: onAceptar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("ACEPTAR OFERTA"),
                ): const SizedBox.shrink(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Widget simple para filas de información
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}