part of 'filtro_bloc.dart';

sealed class FiltroEvent extends Equatable {
  const FiltroEvent();
  @override
  List<Object> get props => [];
}

class CambiarOficio extends FiltroEvent {
  final String oficio;
  const CambiarOficio(this.oficio);
  @override
  List<Object> get props => [oficio];
}

class CambiarCercania extends FiltroEvent {
  final String cercania;
  const CambiarCercania(this.cercania);
  @override
  List<Object> get props => [cercania];
}

class CargarNecesidades extends FiltroEvent {
  final List<Map<String, String>> necesidades;
  const CargarNecesidades(this.necesidades);
  @override
  List<Object> get props => [necesidades];
}
