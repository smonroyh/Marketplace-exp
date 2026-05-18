

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart';
import 'package:push_app/presentation/screens/auth_screen.dart';
import 'package:push_app/presentation/screens/formulario_necesidad_screen.dart';
import 'package:push_app/presentation/screens/miSolicitudDetalle.dart';
import 'package:push_app/presentation/screens/necesidad_detalle_screen.dart';
import 'package:push_app/presentation/screens/profile_setup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/screens/trabajadorView/Detalle/DetalleSolicitudWorker.dart';
import 'package:push_app/presentation/screens/trabajadorView/mainWorkerScreen.dart';

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
  }
}

final _authChangeNotifier = _AuthChangeNotifier();

final appRouter = GoRouter(
  refreshListenable: _authChangeNotifier,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null && state.uri.path != '/') {
      return '/';
    }
    return null;
  },
  routes: [
    // GoRoute(
    //   path: "/",
    //   builder: (context, state) => const HomeScreen(),
    //   routes:[
    //     GoRoute(path: "/necesidad-detalle",
    //     builder: (context, state)  {

    //       return NecesidadDetalleScreen(need: state.extra as Map<String,String>,);
    //     }
    //     )
    //   ]
    // )
    GoRoute(
      path: "/",
      builder: (context, state) => const AuthScreen(),
      routes:[
        GoRoute(
          path: "/necesidad-detalle",
          builder: (context, state) {
            return NecesidadDetalleScreen(need: state.extra as Map<String,String>,);
          }
        ),
        GoRoute(
          path: "/profile-setup",
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ProfileSetupScreen(
              userId: extra['userId'] as String,
              rol: extra['rol'] as UserRole,
            );
          }
        ),

        GoRoute(path: "mis-solicitudes/solicitud/:solicitudId",
        builder: (context, state)  {
          final extra = state.extra as Map<String, dynamic>;
          return SolicitudDetailScreen(
            solicitud: extra['solicitud'] as Solicitud,
            solicitudesBloc: context.read<SolicitudesBloc>(),
          );
        }
        ),

        GoRoute(path: "mis-solicitudes/nueva",
        builder: (context, state)  {
          return FormularioNecesidadScreen();
        }
        )
      ]
    ),

    GoRoute(
      path: "/worker",
      builder: (context, state) => const MainWorkerScreen(),
      routes: [
        GoRoute(
          path: "/solicitud/:solicitudId",
          builder: (context, state)  {
            final extra = state.extra as Map<String, dynamic>;
            return SolicitudDetailWorkerScreen(
              solicitud: extra['solicitud'] as Solicitud,
            );
          }
        )
      ]
    )
  ]
  
);