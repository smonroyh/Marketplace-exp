import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/config/router/app_router.dart';
import 'package:push_app/config/theme/app_theme.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/bloc/notifications_bloc.dart';
import 'package:push_app/presentation/blocs/profile/profile_bloc.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart';
import 'package:push_app/presentation/blocs/workerFeed/worker_feed_bloc.dart';
import 'package:push_app/presentation/screens/auth_screen.dart';
import 'package:push_app/presentation/screens/home_screen.dart';
import 'package:push_app/presentation/screens/trabajadorView/trabajadorFeedScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationsBloc.initializeFirebaseNotifications();
  
  runApp(
    MultiBlocProvider(

      providers: [
        BlocProvider(
          create: (context) => NotificationsBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(),
          child: AuthScreen()
            // child: AuthScreen(),
          ),
        BlocProvider(
          create: (context) => SolicitudesBloc(),
        ),

        BlocProvider(
          create: (context) => WorkerFeedBloc()..add( WorkerSubscriptionRequested(misCategorias: ['Otro' , 'Jardinería']) ),
          child: WorkerFeedScreen(),
        ),

        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: const MainApp())
    );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      routerConfig: appRouter, 
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
    );
  }
}
