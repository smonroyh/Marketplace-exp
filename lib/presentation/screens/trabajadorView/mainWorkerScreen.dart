import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:push_app/presentation/blocs/workerFeed/worker_feed_bloc.dart';
import 'package:push_app/presentation/screens/auth_screen.dart';
import 'package:push_app/presentation/screens/trabajadorView/trabajadorFeedScreen.dart';
import 'package:push_app/presentation/screens/trabajadorView/misPostulacionesScreen.dart';
import 'package:push_app/presentation/screens/trabajadorView/trabajosActivosScreen.dart';
import 'package:push_app/presentation/screens/trabajadorView/perfilTrabajadorScreen.dart';

class MainWorkerScreen extends StatefulWidget {
  const MainWorkerScreen({super.key});

  @override
  State<MainWorkerScreen> createState() => _MainWorkerScreenState();
}

class _MainWorkerScreenState extends State<MainWorkerScreen> {
  int _selectedIndex = 0;
  String? userId = "";

  @override
  void initState() {
    super.initState();

    userId = context.read<AuthBloc>().state.userId;
    if (userId != null && userId!.isNotEmpty) {
      context.read<ProfileBloc>().add(LoadProfile(uid: userId!));
    }
  }

  // Lista de pantallas principales
  final List<Widget> _pages = [
    const WorkerFeedScreen(), // Explorar
    const MisPostulacionesScreen(), // Gestión de ofertas enviadas
    const TrabajosActivosScreen(),  // Lo que está haciendo ahora
    const PerfilTrabajadorScreen(), // Perfil, ingresos y reviews
  ];


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous.userId != current.userId,
              listener: (context, state) {
                print(state.userId);
                // TODO: implement listener
                // if (state.userId != null) {
                //   context.read<ProfileBloc>().add(
                //     LoadProfile(uid: state.userId!),
                //   );
                // }
              },
            ),
            BlocListener<ProfileBloc, ProfileState>(
              listenWhen: (previous, current) =>
                  previous.usuario != current.usuario &&
                  current.status == FormzSubmissionStatus.success,
              listener: (context, state) {
                // TODO: implement listener
                if (state.usuario != null) {
                  // context.read<WorkerFeedBloc>().add(WorkerSubscriptionRequested(misCategorias: state.usuario!.oficios ));
                  context.read<WorkerFeedBloc>().add(
                    WorkerSubscriptionRequested(
                      misCategorias: ["Otro", "Jardinería"],
                    ),
                  );
                }
              },
            ),
          ],
          child: userId != null ? _workerNavigationScaffold() : AuthScreen(),
        );
      },
    );
  }

  Scaffold _workerNavigationScaffold() {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed, // Mantiene los iconos fijos
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF09090B),
        unselectedItemColor: const Color(0xFFA1A1AA),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Mis Ofertas'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman_outlined), activeIcon: Icon(Icons.handyman), label: 'Activos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
