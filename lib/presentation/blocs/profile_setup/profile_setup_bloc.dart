import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formz/formz.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';
import 'profile_setup_event.dart';
import 'profile_setup_state.dart';

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  ProfileSetupBloc({
    required String userId,
    required UserRole rol,
  }) : super(ProfileSetupState(userId: userId, rol: rol)) {
    on<NombreChanged>((event, emit) {
      emit(state.copyWith(nombre: event.nombre, errorMessage: null));
    });
    on<TelefonoChanged>((event, emit) {
      emit(state.copyWith(telefono: event.telefono, errorMessage: null));
    });
    on<DireccionChanged>((event, emit) {
      emit(state.copyWith(direccion: event.direccion, errorMessage: null));
    });
    on<OficiosChanged>((event, emit) {
      emit(state.copyWith(oficios: event.oficios, errorMessage: null));
    });
    on<ExperienciaChanged>((event, emit) {
      emit(state.copyWith(experiencia: event.experiencia, errorMessage: null));
    });
    on<DisponibilidadChanged>((event, emit) {
      emit(state.copyWith(disponibilidad: event.disponibilidad, errorMessage: null));
    });
    on<ProfileSetupSubmitted>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress, isLoading: true));
      try {
        final userData = <String, dynamic>{
          'nombre': state.nombre.trim(),
          'telefono': state.telefono.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (state.rol == UserRole.cliente) {
          userData['direccion'] = state.direccion.trim();
        } else if (state.rol == UserRole.trabajador) {
          userData['oficios'] = state.oficios;
          userData['experiencia'] = state.experiencia.trim();
          userData['disponibilidad'] = state.disponibilidad;
        }
        userData['profileCompleted'] = true;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(state.userId)
            .update(userData);

        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ));
      }
    });
  }
}

