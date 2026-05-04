part of 'solicitudes_bloc.dart';


class SolicitudesState extends Equatable {
  const SolicitudesState();
  @override
  List<Object> get props => [];
}


class SolicitudesInitial extends SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

class SolicitudesLoaded extends SolicitudesState {


  final List<Solicitud> solicitudes;
  final SolicitudStatus? filtroActual;

  const SolicitudesLoaded({required this.solicitudes,  this.filtroActual = SolicitudStatus.pendiente});

  SolicitudesLoaded copyWith({
    List<Solicitud>? solicitudes,
    SolicitudStatus? filtroActual,
  }) {
    return SolicitudesLoaded(
      solicitudes: solicitudes ?? this.solicitudes,
      filtroActual: filtroActual ?? this.filtroActual,
    );
  }

  @override
  List<Object> get props => [solicitudes, ?filtroActual];
}