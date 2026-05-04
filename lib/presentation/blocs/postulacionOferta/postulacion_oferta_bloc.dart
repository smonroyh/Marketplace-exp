import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:push_app/entities/usuarios.dart';
import 'package:push_app/infraestructure/inputs/monto.dart';

part 'postulacion_oferta_event.dart';
part 'postulacion_oferta_state.dart';

class PostulacionOfertaBloc extends Bloc<PostulacionOfertaEvent, PostulacionOfertaState> {

  final _firestore = FirebaseFirestore.instance;


  PostulacionOfertaBloc() : super(const PostulacionOfertaState()) {
    on<PostulacionOfertaEvent>((event, emit) {
      // TODO: implement event handler
    });

    // Dentro de PostulacionBloc...
    on<FormSubmitted>((event, emit) async {

      // if (state.monto <= 0) return;
   
      if (!Formz.validate([state.monto])) return;

      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      
      try {
        await _firestore
            .collection('solicitudes')
            .doc(event.solicitudId)
            .collection('ofertas')
            .add({
          'trabajadorId': event.trabajador.uid,
          'nombreTrabajador': event.trabajador.nombre,
          'monto': state.monto.value,
          'mensaje': state.mensaje,
          'fechaOferta': FieldValue.serverTimestamp(),
          'status': 'pendiente',
          "ratingTrabajador" : event.trabajador.rating,
          'fotoTrabajadorUrl' : event.trabajador.fotoUrl,
        });

        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
      }
    });


    on<MontoChanged>((event, emit) {
      emit(state.copyWith(monto: event.monto));
    });

    on<MensajeChanged>((event, emit) {
      emit(state.copyWith(mensaje: event.mensaje));
    });


    on<CheckForExistentOffers>((event, emit) async {
      try {

      final snapOferta = await FirebaseFirestore.instance
          .collection('solicitudes')
          .doc(event.solicitudId)
          .collection("ofertas")
          .where('trabajadorId', isEqualTo: event.trabajador.uid)
          .get();
      
      snapOferta.docs.isNotEmpty ? emit(state.copyWith(alreadySent: true)) : emit(state.copyWith(alreadySent: false));

      

      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
      }
    });
  }
}
