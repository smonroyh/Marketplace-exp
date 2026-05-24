import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:push_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:push_app/presentation/blocs/auth/auth_event.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'package:push_app/presentation/blocs/profile_setup/profile_setup_bloc.dart';
import 'package:push_app/presentation/blocs/profile_setup/profile_setup_event.dart';
import 'package:push_app/presentation/blocs/profile_setup/profile_setup_state.dart';

class ProfileSetupScreen extends StatelessWidget {
  final String userId;
  final UserRole rol;

  const ProfileSetupScreen({
    super.key,
    required this.userId,
    required this.rol,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileSetupBloc(userId: userId, rol: rol),
      child: BlocListener<ProfileSetupBloc, ProfileSetupState>(
        listener: (context, state)  {
          if (state.status == FormzSubmissionStatus.success) {
            context.read<AuthBloc>().add(AuthProfileStatusRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil completado exitosamente')),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(rol == UserRole.cliente ? 'Completa tu perfil' : 'Configura tu perfil'),
                centerTitle: false,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: rol == UserRole.cliente
                    ? _buildClienteForm(context, state)
                    : _buildTrabajadorForm(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildClienteForm(BuildContext context, ProfileSetupState state) {
    final bloc = context.read<ProfileSetupBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Información del Cliente',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        const SizedBox(height: 24),
        TextField(
          onChanged: (value) => bloc.add(NombreChanged(value)),
          decoration: const InputDecoration(labelText: 'Nombre completo'),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => bloc.add(TelefonoChanged(value)),
          decoration: const InputDecoration(labelText: 'Teléfono'),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => bloc.add(DireccionChanged(value)),
          decoration: const InputDecoration(labelText: 'Dirección'),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () => bloc.add(ProfileSetupSubmitted()),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Completar perfil'),
              ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildTrabajadorForm(BuildContext context, ProfileSetupState state) {
    final bloc = context.read<ProfileSetupBloc>();
    final oficiosDisponibles = [
      'Plomería',
      'Electricidad',
      'Carpintería',
      'Jardinería',
      'Pintura',
      'Albañilería'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Información del Trabajador',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        const SizedBox(height: 24),
        TextField(
          onChanged: (value) => bloc.add(NombreChanged(value)),
          decoration: const InputDecoration(labelText: 'Nombre completo'),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => bloc.add(TelefonoChanged(value)),
          decoration: const InputDecoration(labelText: 'Teléfono'),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        const Text('Oficios:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: oficiosDisponibles.map((oficio) {
            final isSelected = state.oficios.contains(oficio);
            return FilterChip(
              label: Text(oficio, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF09090B))),
              selected: isSelected,
              selectedColor: const Color(0xFF09090B),
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                final nuevosOficios = List<String>.from(state.oficios);
                if (selected) {
                  nuevosOficios.add(oficio);
                } else {
                  nuevosOficios.remove(oficio);
                }
                bloc.add(OficiosChanged(nuevosOficios));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => bloc.add(ExperienciaChanged(value)),
          decoration: const InputDecoration(labelText: 'Años de experiencia'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Disponibilidad: '),
            Switch(
              value: state.disponibilidad,
              onChanged: (value) => bloc.add(DisponibilidadChanged(value)),
            ),
            Text(state.disponibilidad ? 'Disponible' : 'No disponible'),
          ],
        ),
        const SizedBox(height: 24),
        state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () => bloc.add(ProfileSetupSubmitted()),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Completar perfil'),
              ),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

