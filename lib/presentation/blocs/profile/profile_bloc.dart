import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:push_app/entities/usuarios.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProfileBloc() : super(ProfileState(status: FormzSubmissionStatus.initial)) {


    on<LoadProfile>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final doc = await _firestore.collection('users').doc(event.uid).get();
        if (doc.exists) {
          emit(state.copyWith(
            usuario: Usuario.fromFirestore(doc),
            status: FormzSubmissionStatus.success,
          ));
        }
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });
  }
}
