import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';
import 'package:push_app/presentation/blocs/publicaciones/publicaciones_bloc_bloc.dart';
import 'package:push_app/presentation/screens/formulario_necesidad_screen.dart';
import 'package:push_app/presentation/screens/misSolicitudesView.dart';
import 'package:push_app/widgets/publicaciones/publicacionCard.dart';
import 'necesidad_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    final blocAuth = context.read<AuthBloc>();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PublicacionesBlocBloc()..add(LoadedPublicacionesRequested())),],
      child: Scaffold(
        appBar: AppBar(
          title: context.select(
            (NotificationsBloc bloc) => Text('${bloc.state.status}'),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                //TODO: Solicitar permisos
                context.read<NotificationsBloc>().requestPermission();
              },
            ),

            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                //TODO: Solicitar permisos
                blocAuth.add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _indexSelected,
          children: [
            // const _HomeView(),
            const _SearchHomeView(),
            MisSolicitudesView(),
            // FormularioNecesidadScreen(),
            NecesidadListScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificaciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Necesidades',
            ),
          ],
          currentIndex: _indexSelected,
          onTap: (index) {
            setState(() {
              _indexSelected = index;
            });
          },
        ),
      ),
    );
  }
}

class _SearchHomeView extends StatelessWidget {
  const _SearchHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionesBlocBloc, PublicacionesBlocState>(
      builder: (context, state) {
        if (state is PublicacionesLoading) {
          // context.read<PublicacionesBlocBloc>().add(LoadedPublicacionesRequested());
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PublicacionesLoaded) {
          return ListView.builder(
            itemCount: state.publicaciones.length,
            itemBuilder: (context, index) {
              // Widget que muestra los detalles de la publicación (ej. Tarjeta de Trabajo)
              return PublicacionCard(publicacion: state.publicaciones[index]);
            },
          );
        }
        return const Center(child: Text('No hay servicios disponibles.'));
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();

    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Permiso ${bloc.state.userId}'),
          subtitle: Text('Estado del permiso $index'),
          trailing: Icon(Icons.check, color: Colors.green),
        );
      },
    );
  }
}
