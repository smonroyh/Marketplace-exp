import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/screens/home_screen.dart';
import 'package:push_app/presentation/screens/trabajadorView/mainWorkerScreen.dart';
import 'package:push_app/presentation/screens/trabajadorView/trabajadorFeedScreen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final bloc = context.read<AuthBloc>();
        if (!state.profileCompleted &&
            state.userId != null &&
            state.userId!.isNotEmpty &&
            state.selectedRole != null &&
            !state.isNavigatingToProfile) {
          bloc.add(IsNavigatingToProfileChanged(true));
          context
              .push(
                '/profile-setup',
                extra: {'userId': state.userId!, 'rol': state.selectedRole!},
              )
              .whenComplete(() {
                bloc.add(IsNavigatingToProfileChanged(false));
              });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {

          print("BUILDER DEL AUTHSCREEN");
          if (state.profileCompleted && state.userId != null && state.selectedRole == UserRole.cliente) {
            return const HomeScreen();
          }
          if (state.profileCompleted && state.userId != null && state.selectedRole == UserRole.trabajador) {
            // return const WorkerFeedScreen();
            return const MainWorkerScreen();
          }

          return Scaffold(
            appBar: AppBar(
              title: _getAppBarTitle(state.flowStep, state.selectedRole),
              leading: state.flowStep != AuthFlowStep.initial
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          context.read<AuthBloc>().add(GoBackToInitial()),
                    )
                  : null,
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildContent(context, state, context.read<AuthBloc>()),
              ),
            ),
          );
        },
      ),
      // child: AuthScreen(),
    );
  }

  Widget _getAppBarTitle(AuthFlowStep step, UserRole? role) {
    switch (step) {
      case AuthFlowStep.initial:
        return const Text('Bienvenido');
      case AuthFlowStep.selectingRole:
        return const Text('Tipo de Usuario');
      case AuthFlowStep.loginForm:
        return const Text('Iniciar Sesión');
      case AuthFlowStep.registerForm:
        return const Text('Crear Cuenta');
      case AuthFlowStep.profileSetup:
        return const Text('Configura tu perfil');
      case AuthFlowStep.home:
        return Text('${role.toString()}');
    }
  }

  Widget _buildContent(BuildContext context, AuthState state, AuthBloc bloc) {
    switch (state.flowStep) {
      case AuthFlowStep.initial:
        return _buildInitialScreen(state, bloc);
      case AuthFlowStep.selectingRole:
        return _buildRoleSelectionScreen(state, bloc);
      case AuthFlowStep.loginForm:
        return _buildLoginForm(state, bloc);
      case AuthFlowStep.registerForm:
        return _buildRegisterForm(state, bloc);
      case AuthFlowStep.profileSetup:
      case AuthFlowStep.home:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInitialScreen(AuthState state, AuthBloc bloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Bienvenido',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          onPressed: () => bloc.add(ShowLoginForm()),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Iniciar Sesión'),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => bloc.add(ShowRegisterOptions()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Crear Cuenta'),
        ),
      ],
    );
  }

  Widget _buildRoleSelectionScreen(AuthState state, AuthBloc bloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '¿Qué tipo de usuario eres?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => bloc.add(SelectUserRole(UserRole.cliente)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
          ),
          child: const Text('Cliente'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => bloc.add(SelectUserRole(UserRole.trabajador)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 60),
          ),
          child: const Text('Trabajador'),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthState state, AuthBloc bloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: state.emailController,
          onChanged: (value) => bloc.add(AuthEmailChanged(value)),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: state.passwordController,
          onChanged: (value) => bloc.add(AuthPasswordChanged(value)),
          decoration: const InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        state.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => bloc.add(AuthLoginSubmitted()),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Iniciar Sesión'),
              ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (state.userId != null && state.userId!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 24),
              Text(
                '¡Bienvenido! UID: ${state.userId}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRegisterForm(AuthState state, AuthBloc bloc) {
    final roleText = state.selectedRole == UserRole.cliente
        ? 'Cliente'
        : 'Trabajador';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Registro como $roleText',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: state.emailController,
          onChanged: (value) => bloc.add(AuthEmailChanged(value)),
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: state.passwordController,
          onChanged: (value) => bloc.add(AuthPasswordChanged(value)),
          decoration: const InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        state.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => bloc.add(AuthRegisterSubmitted()),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Registrar'),
              ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (state.userId != null && state.userId!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 24),
              Text(
                '¡Cuenta creada! UID: ${state.userId}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
      ],
    );
  }
}
