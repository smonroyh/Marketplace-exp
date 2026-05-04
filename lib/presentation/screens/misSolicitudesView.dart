import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/entities/solicitudes.dart';

import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart';
import 'package:push_app/widgets/solicitudes/solicitudCard.dart';
class MisSolicitudesView extends StatelessWidget {
  const MisSolicitudesView({super.key});

  

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario autenticado del AuthBloc
    final authState = context.read<AuthBloc>().state;
    final userId = authState.userId;

    
    // 1. Reutiliza el BLoC global en lugar de crear uno nuevo
    return BlocProvider.value(
      value: context.read<SolicitudesBloc>()..add(LoadSolicitudes(status: SolicitudStatus.pendiente, clientId: userId!)),
      child: BlocBuilder<SolicitudesBloc, SolicitudesState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 4, // Pendiente, Activa, Completada, Cancelada
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  TextButton.icon(onPressed: (){
                    context.push('/mis-solicitudes/nueva');
                  }, 
                    label: Text("Nueva solicitud", 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)) ,icon: const Icon(Icons.add, size: 28)),             
                ],
                
                actionsIconTheme : const IconThemeData(size: 28),
                automaticallyImplyLeading: false, // Es una vista de navegación
                title: const Text('Solicitudes', style: TextStyle(fontSize: 24, )),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: _buildTabBar(context, userId!), // La barra de pestañas
                ),
              ),
              body: TabBarView(
                children: [
                  // Cada tab utiliza el mismo widget de lista, filtrado por estado
                  _solicitudesListView(context, state, status: SolicitudStatus.pendiente),
                  _solicitudesListView(context, state, status: SolicitudStatus.activa),
                  _solicitudesListView(context, state, status: SolicitudStatus.completada),
                  _solicitudesListView(context, state, status: SolicitudStatus.cancelada),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget para crear la TabBar de filtrado
  Widget _buildTabBar(BuildContext context, String clientId) {
    return TabBar(
      isScrollable: true, // Útil si añades más estados
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: const [
        Tab(text: 'PENDIENTES'),
        Tab(text: 'ACTIVAS'),
        Tab(text: 'COMPLETADAS'),
        Tab(text: 'CANCELADAS'),
      ],
      // Opcional: Ejecutar la carga al cambiar de pestaña
      onTap: (index) {
        final status = SolicitudStatus.values[index];
        context.read<SolicitudesBloc>().add(LoadSolicitudes(status: status, clientId: clientId));
      },
    );
  }

  Widget _solicitudesListView(BuildContext context, SolicitudesState state, {required SolicitudStatus status}) {
    final SolicitudStatus filterStatus = status;

    List<Solicitud> filteredSolicitudes = [];

    if (state is SolicitudesLoaded) {
      filteredSolicitudes = state.solicitudes
          .where((s) => s.status == filterStatus)
          .toList();
    }

    if (state is SolicitudesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredSolicitudes.isEmpty) {
      return Center(
        child: Text(
          'No tienes solicitudes ${filterStatus.name}s.',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: filteredSolicitudes.length,
      itemBuilder: (context, index) {
        final solicitud = filteredSolicitudes[index];
        return SolicitudCard(
          solicitud: solicitud,
          onTap: () {
            // Navegar a la pantalla de detalle de la solicitud
            context.push('/mis-solicitudes/solicitud/${solicitud.id}',
            extra: {
              "solicitud" : solicitud
            });
          },
        );
      },
    );
  }
}
