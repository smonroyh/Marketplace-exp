import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';

class PerfilClienteScreen extends StatelessWidget {
  const PerfilClienteScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text('¿Estás seguro que deseas salir?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF71717A)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final email = state.email.isNotEmpty ? state.email : 'cliente@tepo.com';
        final name = email.split('@')[0].toUpperCase();
        final avatarLetter = name.isNotEmpty ? name[0] : 'U';

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header: Título Perfil ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE4E4E7)),
                      ),
                    ),
                    child: const Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF09090B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  // --- User Section ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE4E4E7)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE4E4E7)),
                          ),
                          child: Center(
                            child: Text(
                              avatarLetter,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF09090B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF09090B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF71717A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE4E4E7)),
                          ),
                          child: const Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF09090B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Sección: Mi Cuenta ---
                  _buildSectionHeader('Mi Cuenta'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem('👤', 'Información Personal', showBorder: true),
                          _buildMenuItem('💳', 'Métodos de Pago', showBorder: true),
                          _buildMenuItem('❤️', 'Trabajadores Guardados', showBorder: false),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Sección: Configuración ---
                  _buildSectionHeader('Configuración'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem('🔔', 'Notificaciones', showBorder: true),
                          _buildMenuItem('🔒', 'Privacidad y Seguridad', showBorder: false),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Sección: Soporte ---
                  _buildSectionHeader('Soporte'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem('❓', 'Centro de Ayuda', showBorder: true),
                          _buildMenuItem('📄', 'Términos de Servicio', showBorder: false),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- Botón Cerrar Sesión ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () => _confirmLogout(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFEE2E2)),
                        ),
                        child: const Center(
                          child: Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF71717A),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String icon, String label, {required bool showBorder}) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xFFF4F4F5)),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF09090B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '›',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFA1A1AA),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
