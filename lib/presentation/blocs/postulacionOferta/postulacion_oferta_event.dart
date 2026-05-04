part of 'postulacion_oferta_bloc.dart';

sealed class PostulacionOfertaEvent extends Equatable {
  const PostulacionOfertaEvent();

  @override
  List<Object> get props => [];
}

class MontoChanged extends PostulacionOfertaEvent {
  final double monto;
  const MontoChanged(this.monto);
  @override List<Object> get props => [monto];
}

class MensajeChanged extends PostulacionOfertaEvent {
  final String mensaje;
  const MensajeChanged(this.mensaje);
  @override List<Object> get props => [mensaje];
}

class FormSubmitted extends PostulacionOfertaEvent {
  final String solicitudId;
  final Usuario trabajador;
  const FormSubmitted({required this.solicitudId, required this.trabajador});
  @override List<Object> get props => [solicitudId, trabajador];
}


class CheckForExistentOffers extends PostulacionOfertaEvent {
  final String solicitudId;
  final Usuario trabajador;
  const CheckForExistentOffers({required this.solicitudId, required this.trabajador});
  @override List<Object> get props => [solicitudId, trabajador];
}
