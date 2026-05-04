part of 'filtro_bloc.dart';

sealed class FiltroState extends Equatable {
  const FiltroState();
  @override
  List<Object> get props => [];
}

class FiltroInitial extends FiltroState {}

class FiltroLoaded extends FiltroState {
  final List<Map<String, String>> necesidades;
  final String oficioSelected;
  final String cercaniaSelected;

  const FiltroLoaded({
    required this.necesidades,
    required this.oficioSelected,
    required this.cercaniaSelected,
  });

  FiltroLoaded copyWith({
    List<Map<String, String>>? necesidades,
    String? oficioSelected,
    String? cercaniaSelected,
  }) => FiltroLoaded(
    necesidades: necesidades ?? this.necesidades,
    oficioSelected: oficioSelected ?? this.oficioSelected,
    cercaniaSelected: cercaniaSelected ?? this.cercaniaSelected,
  );

  List<Map<String,String>> get necesidadesFiltradas => necesidades.where((n) {
    final coincideOficio = oficioSelected == "Todos" || n["oficio"]==oficioSelected;
    final coincideCercania = n["distancia"]==cercaniaSelected;
    return coincideOficio && coincideCercania;
  }).toList();

  @override
  List<Object> get props => [necesidades, oficioSelected, cercaniaSelected];
}


