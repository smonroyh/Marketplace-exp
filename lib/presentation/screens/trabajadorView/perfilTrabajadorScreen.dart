import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';

class PerfilTrabajadorScreen extends StatelessWidget {
  const PerfilTrabajadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Perfil Header
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE4E4E7)),
                  ),
                  child: const Icon(Icons.person, size: 32, color: Color(0xFF09090B)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mi Cuenta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Trabajador Activo', style: TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Editar'),
                )
              ],
            ),
            const SizedBox(height: 48),

            // Opciones
            _buildOpcion(icon: Icons.star_border, title: 'Mis Reseñas', subtitle: 'Aún no tienes reseñas'),
            _buildOpcion(icon: Icons.account_balance_wallet_outlined, title: 'Ganancias', subtitle: 'Historial de pagos'),
            _buildOpcion(icon: Icons.settings_outlined, title: 'Configuración', subtitle: 'Notificaciones, privacidad'),
            _buildOpcion(icon: Icons.help_outline, title: 'Soporte', subtitle: 'Centro de ayuda'),

            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEF2F2),
                foregroundColor: const Color(0xFFEF4444),
                elevation: 0,
              ),
              child: const Text('Cerrar Sesión'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOpcion({required IconData icon, required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF09090B)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF71717A), fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFA1A1AA)),
        ],
      ),
    );
  }
}
