part of 'solicitud_detalle_cubit.dart';

sealed class SolicitudDetalleState extends Equatable {
  const SolicitudDetalleState();

  @override
  List<Object> get props => [];
}

final class SolicitudDetalleInitial extends SolicitudDetalleState {}
final class SolicitudDetalleLoading extends SolicitudDetalleState {}

final class SolicitudDetalleLoaded extends SolicitudDetalleState {

  final Solicitud solicitud;

  const SolicitudDetalleLoaded({required this.solicitud});

  @override
  List<Object> get props => [solicitud];
}

final class SolicitudDetalleError extends SolicitudDetalleState {

  final String message;

  const SolicitudDetalleError({required this.message});

  @override
  List<Object> get props => [message];
}