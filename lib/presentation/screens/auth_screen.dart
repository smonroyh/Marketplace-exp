import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/screens/home_screen.dart';
import 'package:push_app/presentation/screens/trabajadorView/mainWorkerScreen.dart';
import 'package:push_app/presentation/screens/trabajadorView/trabajadorFeedScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/screens/home_screen.dart';
import 'package:push_app/presentation/screens/trabajadorView/mainWorkerScreen.dart';

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
            return const MainWorkerScreen();
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Custom Header: Botón de Volver/Cerrar ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (state.flowStep == AuthFlowStep.initial) {
                              // Si es la inicial, podemos cerrar o ir atrás en el router si se puede
                              if (context.canPop()) {
                                context.pop();
                              }
                            } else {
                              context.read<AuthBloc>().add(GoBackToInitial());
                            }
                          },
                          icon: Text(
                            state.flowStep == AuthFlowStep.initial ? '✕' : '‹',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              color: Color(0xFF09090B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Body Scroll ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildContent(context, state, context.read<AuthBloc>()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        // Logo de Tepo
        const Text(
          'tepo.',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: Color(0xFF09090B),
            letterSpacing: -2.0,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Encuentra a los mejores profesionales o comienza a ofrecer tus servicios hoy mismo.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF71717A),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 120),

        // Botones de acción
        InkWell(
          onTap: () => bloc.add(ShowLoginForm()),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF09090B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Color(0xFFFAFAFA),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => bloc.add(ShowRegisterOptions()),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE4E4E7)),
            ),
            child: const Center(
              child: Text(
                'Crear Cuenta',
                style: TextStyle(
                  color: Color(0xFF09090B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () {
              // Simular continuar como invitado
            },
            child: const Text(
              'Continuar como invitado',
              style: TextStyle(
                color: Color(0xFF71717A),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelectionScreen(AuthState state, AuthBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          '¿Cómo usarás tepo?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF09090B),
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Selecciona la opción que mejor describa lo que buscas.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF71717A),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),

        // Tarjeta Cliente
        _buildRoleCard(
          title: 'Busco servicios',
          description: 'Quiero contratar a profesionales locales.',
          icon: '🔍',
          onTap: () => bloc.add(SelectUserRole(UserRole.cliente)),
        ),
        const SizedBox(height: 16),

        // Tarjeta Trabajador
        _buildRoleCard(
          title: 'Ofrezco servicios',
          description: 'Soy profesional y busco nuevos clientes.',
          icon: '🛠️',
          onTap: () => bloc.add(SelectUserRole(UserRole.trabajador)),
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E4E7), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF09090B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF71717A),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthState state, AuthBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF09090B),
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Bienvenido de vuelta a tepo.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF71717A),
          ),
        ),
        const SizedBox(height: 48),

        // Campo Email
        const Text(
          'Correo electrónico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF09090B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: state.emailController,
            onChanged: (value) => bloc.add(AuthEmailChanged(value)),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 16, color: Color(0xFF09090B)),
            decoration: const InputDecoration(
              hintText: 'nombre@ejemplo.com',
              hintStyle: TextStyle(color: Color(0xFFA1A1AA)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Campo Contraseña
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF09090B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: state.passwordController,
            onChanged: (value) => bloc.add(AuthPasswordChanged(value)),
            obscureText: true,
            style: const TextStyle(fontSize: 16, color: Color(0xFF09090B)),
            decoration: const InputDecoration(
              hintText: 'Tu contraseña',
              hintStyle: TextStyle(color: Color(0xFFA1A1AA)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Olvidaste contraseña
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              '¿Olvidaste tu contraseña?',
              style: TextStyle(
                color: Color(0xFF71717A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Error message
        if (state.errorMessage != null) ...[
          Text(
            state.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],

        // Botón Entrar
        state.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF09090B)))
            : InkWell(
                onTap: () => bloc.add(AuthLoginSubmitted()),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09090B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        color: Color(0xFFFAFAFA),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildRegisterForm(AuthState state, AuthBloc bloc) {
    final isClient = state.selectedRole == UserRole.cliente;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Crea tu cuenta',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF09090B),
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isClient
              ? 'Comienza a explorar servicios locales.'
              : 'Únete a nuestra red de profesionales.',
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF71717A),
          ),
        ),
        const SizedBox(height: 48),

        // Campo Email
        const Text(
          'Correo electrónico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF09090B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: state.emailController,
            onChanged: (value) => bloc.add(AuthEmailChanged(value)),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 16, color: Color(0xFF09090B)),
            decoration: const InputDecoration(
              hintText: 'nombre@ejemplo.com',
              hintStyle: TextStyle(color: Color(0xFFA1A1AA)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Campo Contraseña
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF09090B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: state.passwordController,
            onChanged: (value) => bloc.add(AuthPasswordChanged(value)),
            obscureText: true,
            style: const TextStyle(fontSize: 16, color: Color(0xFF09090B)),
            decoration: const InputDecoration(
              hintText: 'Mínimo 6 caracteres',
              hintStyle: TextStyle(color: Color(0xFFA1A1AA)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Error message
        if (state.errorMessage != null) ...[
          Text(
            state.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],

        // Botón Registrar
        state.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF09090B)))
            : InkWell(
                onTap: () => bloc.add(AuthRegisterSubmitted()),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF09090B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        color: Color(0xFFFAFAFA),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
