import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';

// enum UserRole { cliente, trabajador }

class ProfileSetupState extends Equatable {
  final String userId;
  final UserRole rol;
  final String nombre;
  final String telefono;
  final String direccion;
  final List<String> oficios;
  final String experiencia;
  final bool disponibilidad;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final bool isLoading;

  const ProfileSetupState({
    required this.userId,
    required this.rol,
    this.nombre = '',
    this.telefono = '',
    this.direccion = '',
    this.oficios = const [],
    this.experiencia = '',
    this.disponibilidad = true,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.isLoading = false,
  });

  ProfileSetupState copyWith({
    String? userId,
    UserRole? rol,
    String? nombre,
    String? telefono,
    String? direccion,
    List<String>? oficios,
    String? experiencia,
    bool? disponibilidad,
    FormzSubmissionStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ProfileSetupState(
      userId: userId ?? this.userId,
      rol: rol ?? this.rol,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      oficios: oficios ?? this.oficios,
      experiencia: experiencia ?? this.experiencia,
      disponibilidad: disponibilidad ?? this.disponibilidad,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    userId, rol, nombre, telefono, direccion, oficios, experiencia,
    disponibilidad, status, errorMessage, isLoading
  ];
}

