part of 'solicitudes_bloc.dart';

sealed class SolicitudesEvent extends Equatable {
  const SolicitudesEvent();

  @override
  List<Object> get props => [];
}


final class LoadSolicitudes extends SolicitudesEvent {
  final SolicitudStatus status;
  final String clientId;

  const LoadSolicitudes({required this.status, required this.clientId});

  @override
  List<Object> get props => [status];
}

final class UpdateFiltroSolicitudes extends SolicitudesEvent {
  final SolicitudStatus filtro;

  const UpdateFiltroSolicitudes({required this.filtro});

  @override
  List<Object> get props => [filtro];
}

final class UpdateSolicitud extends SolicitudesEvent {
  final Solicitud solicitud;

  const UpdateSolicitud({required this.solicitud});

  @override
  List<Object> get props => [solicitud];
}




