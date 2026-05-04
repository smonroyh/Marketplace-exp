import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filtro_event.dart';
part 'filtro_state.dart';

class FiltroBloc extends Bloc<FiltroEvent, FiltroState> {
  FiltroBloc() : super(FiltroInitial()) {
    on<CargarNecesidades>((event, emit) {
      emit(FiltroLoaded(
        necesidades: event.necesidades,
        oficioSelected: 'Todos',
        cercaniaSelected: 'Cerca',
      ));
    });
    on<CambiarOficio>((event, emit) {
      final current = state;
      if (current is FiltroLoaded) {
        emit(current.copyWith(oficioSelected: event.oficio));
      }
    });
    on<CambiarCercania>((event, emit) {
      final current = state;
      if (current is FiltroLoaded) {
        emit(current.copyWith(cercaniaSelected: event.cercania));
      }
    });
  }
}
