import 'package:equatable/equatable.dart';

abstract class ProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NombreChanged extends ProfileSetupEvent {
  final String nombre;
  NombreChanged(this.nombre);
  @override
  List<Object?> get props => [nombre];
}

class TelefonoChanged extends ProfileSetupEvent {
  final String telefono;
  TelefonoChanged(this.telefono);
  @override
  List<Object?> get props => [telefono];
}

class DireccionChanged extends ProfileSetupEvent {
  final String direccion;
  DireccionChanged(this.direccion);
  @override
  List<Object?> get props => [direccion];
}

class OficiosChanged extends ProfileSetupEvent {
  final List<String> oficios;
  OficiosChanged(this.oficios);
  @override
  List<Object?> get props => [oficios];
}

class ExperienciaChanged extends ProfileSetupEvent {
  final String experiencia;
  ExperienciaChanged(this.experiencia);
  @override
  List<Object?> get props => [experiencia];
}

class DisponibilidadChanged extends ProfileSetupEvent {
  final bool disponibilidad;
  DisponibilidadChanged(this.disponibilidad);
  @override
  List<Object?> get props => [disponibilidad];
}

class ProfileSetupSubmitted extends ProfileSetupEvent {}

