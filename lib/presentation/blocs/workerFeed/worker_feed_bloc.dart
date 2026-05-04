import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/infraestructure/repository/trabajadorStream.dart';

part 'worker_feed_event.dart';
part 'worker_feed_state.dart';

class WorkerFeedBloc extends Bloc<WorkerFeedEvent, WorkerFeedState> {

  final TrabajadorRepository _repository = TrabajadorRepository();

  WorkerFeedBloc() : super(WorkerFeedInitial()) {
    on<WorkerFeedEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<WorkerSubscriptionRequested>((event, emit) async {
      
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      
      // Asumimos que obtenemos las categorías del perfil del trabajador actual
      await emit.forEach<List<Solicitud>>(
        _repository.getSolicitudesDisponibles(event.misCategorias),
        onData: (data) {
          return state.copyWith(
            status: FormzSubmissionStatus.success,
            solicitudes: data,
          );
        },
        onError: (error, __){
          print(error);
      
          return state.copyWith(status: FormzSubmissionStatus.failure);
        }
        
      );
    });
  }
}
