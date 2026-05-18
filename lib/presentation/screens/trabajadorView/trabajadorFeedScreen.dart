import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/workerFeed/worker_feed_bloc.dart';
// Importa tus blocs, modelos y widgets previos
// import 'package:app/blocs/worker_feed/worker_feed_bloc.dart';
// import 'package:app/widgets/trabajo_disponible_card.dart';

class WorkerFeedScreen extends StatelessWidget {
  const WorkerFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:  Text("Oportunidades${context.read<AuthBloc>().state.userId}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune), // Icono para filtros avanzados
            onPressed: () {
              // TODO: Abrir bottom sheet de filtros (distancia, precio, etc.)
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Icono para logout
            color: Colors.redAccent,
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              print("requesting log out");
              print(context.read<AuthBloc>().state.userId);
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkerFeedBloc, WorkerFeedState>(
        builder: (context, state) {
          
          // 1. Estado de Carga Inicial
          if (state.status == FormzSubmissionStatus.inProgress && state.solicitudes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
          }

          // 2. Error al cargar
          if (state.status == FormzSubmissionStatus.failure) {
            return _ErrorView(onRetry: () {
              context.read<WorkerFeedBloc>().add(const WorkerSubscriptionRequested(misCategorias: ['Plomería', 'Electricidad']));
            });
          }

          // 3. Lista Vacía (No hay trabajos en sus categorías)
          // if (state.solicitudes.isEmpty) {
          //   return _EmptyFeedView();
          // }

          // 3. Lista Vacía (No hay trabajos en sus categorías)
          if (state.solicitudes.isEmpty && state.status == FormzSubmissionStatus.success) {
            
            return _EmptyFeedView();
          }

          // 4. Feed de Trabajos con RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async {
              // Disparamos de nuevo la suscripción o una petición única
              context.read<WorkerFeedBloc>().add(WorkerSubscriptionRequested(misCategorias: ['Otro']));
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: state.solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = state.solicitudes[index];
                return TrabajoDisponibleCard(
                  solicitud: solicitud,
                  onTap: () {
                    // Navegar al detalle para el trabajador
                    context.go('/worker/solicitud/${solicitud.id}',extra: {
                      'solicitud': solicitud,});
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class TrabajoDisponibleCard extends StatelessWidget {
  final Solicitud solicitud;
  final VoidCallback onTap;

  const TrabajoDisponibleCard({super.key, required this.solicitud, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Categoría con estilo de etiqueta
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      solicitud.categoria.toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  Text(
                    "Hace 5 min", // Podrías usar la librería timeago
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                solicitud.titulo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(solicitud.categoria, style: const TextStyle(color: Colors.black54)),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Presupuesto estimado",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "\$${solicitud.presupuesto ?? 'A convenir'}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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

// --- Widgets de Soporte para la UI ---

class _EmptyFeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No hay trabajos cerca',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Asegúrate de tener tus categorías actualizadas o intenta refrescar más tarde.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ups, algo salió mal al cargar el feed.'),
          TextButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}