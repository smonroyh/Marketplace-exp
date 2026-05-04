import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:push_app/entities/publicaciones.dart';

part 'publicaciones_bloc_event.dart';
part 'publicaciones_bloc_state.dart';

class PublicacionesBlocBloc extends Bloc<PublicacionesBlocEvent, PublicacionesBlocState> {
  PublicacionesBlocBloc() : super(PublicacionesLoading()) {


    on<LoadedPublicacionesRequested>((event, emit) async {
      emit(PublicacionesLoading());

      try {
        final querySnap = await FirebaseFirestore.instance
            .collection('publicaciones')
            .get();

        final publicaciones = querySnap.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          return Publicacion(
            id: doc.id,
            nombreTrabajador: data['nombreTrabajador'] as String? ?? '',
            categoria: data['categoria'] as String? ?? '',
            titulo: data['titulo'] as String? ?? '',
            descripcionCorta: data['descripcionCorta'] as String? ?? 'Servicio profesional garantizado.',
            rating: data['rating'] is num ? (data['rating'] as num).toDouble() : 0.0,
            trabajosCompletados: data['trabajosCompletados'] is int
                ? data['trabajosCompletados'] as int
                : (data['trabajosCompletados'] is num
                    ? (data['trabajosCompletados'] as num).toInt()
                    : 0),
            fotoUrl: data['fotoUrl'] as String? ?? 'https://via.placeholder.com/150',
          );
        }).toList();

        emit(PublicacionesLoaded(publicaciones: publicaciones));
      } catch (e) {
        // On error, emit empty list to avoid blocking UI. Consider adding an error state.
        emit(const PublicacionesLoaded(publicaciones: []));
      }




    });

    on<FilterPublicacionesChanged>((event, emit) {
      // TODO: implement event handler
    });
  }
}


