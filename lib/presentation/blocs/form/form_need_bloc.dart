import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:push_app/infraestructure/inputs/presupuesto.dart';
import 'package:push_app/infraestructure/inputs/title.dart';
import 'package:push_app/infraestructure/inputs/description.dart';
import 'package:push_app/infraestructure/inputs/categoria.dart';

part 'form_need_event.dart';
part 'form_need_state.dart';

class FormNeedBloc extends Bloc<FormNeedEvent, FormNeedState> {
  FormNeedBloc() : super(const FormNeedState()) {
    on<TitleChanged>((event, emit) {
      final titulo = TituloInput.dirty(event.value);
      emit(state.copyWith(
          titulo: titulo,
          isValid: Formz.validate([
            titulo,
            state.descripcion,
            state.presupuesto,
            state.categoria,
          ]) ));
    });
    on<DescriptionChanged>((event, emit) {
      final descripcion = DescripcionInput.dirty(event.value);
      emit(state.copyWith(
          descripcion: descripcion,
          isValid: Formz.validate([
            state.titulo,
            descripcion,
            state.categoria,
            state.presupuesto
          ]) ));
    });
    on<CategoriaChanged>((event, emit) {
      final categoria = CategoriaInput.dirty(event.value);
      emit(state.copyWith(
          categoria: categoria,
          isValid: Formz.validate([
            state.titulo,
            state.descripcion,
            state.presupuesto,
            categoria,
          ])));
    });

    on<PresupuestoChanged>((event, emit) {
      final presupuesto = PresupuestoInput.dirty(value: event.value);
      emit(state.copyWith(
          presupuesto: presupuesto,
          isValid: Formz.validate([
            state.titulo,
            state.descripcion,
            state.categoria,
            presupuesto
          ])));
    });

    on<FormNeedSubmitted>((event, emit) async {
      final isValid = Formz.validate([
        state.titulo,
        state.descripcion,
        state.categoria,
        state.presupuesto
      ]);
      if (!isValid ) return;
      // manejar lógica async de subir la necesidad
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await FirebaseFirestore.instance.collection('solicitudes').add({
          'titulo': state.titulo.value,
          'detalles': state.descripcion.value,
          'categoria': state.categoria.value,
          'presupuesto':state.presupuesto.value ,
          // 'ubicacion': 'Ubicación demo', // o state.ubicacion 
          // 'archivos': [], // URLs si se suben archivos
          'fechaCreacion': FieldValue.serverTimestamp(),
          'clienteId': FirebaseAuth.instance.currentUser!.uid,
          "status": 'pendiente',
        });

        emit(state.copyWith(status: FormzSubmissionStatus.success));

      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      
    }

    });
  }
}
