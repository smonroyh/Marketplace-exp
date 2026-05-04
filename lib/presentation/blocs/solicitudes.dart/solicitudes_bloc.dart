import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:push_app/entities/solicitudes.dart';

part 'solicitudes_event.dart';
part 'solicitudes_state.dart';

class SolicitudesBloc extends Bloc<SolicitudesEvent, SolicitudesState> {
  SolicitudesBloc() : super(SolicitudesState()) {

    
    on<LoadSolicitudes>((event, emit) async {
      // TODO: implement event handler
      emit(SolicitudesLoading());

      final snap = await FirebaseFirestore.instance
          .collection('solicitudes')
          .where('status', isEqualTo: event.status.name)
          .where('clienteId', isEqualTo: event.clientId)
          .get();


      final solicitudes = snap.docs.map((doc) {
        final data = doc.data();
        return Solicitud(
          id: doc.id,
          clienteId: data['clienteId'] as String,
          titulo: data['titulo'] as String,
          detalles: data['detalles'] as String,
          status: SolicitudStatus.values.firstWhere(
            (e) => e.name == (data['status'] as String),
            orElse: () => SolicitudStatus.pendiente,
          ),
          presupuesto: (data['presupuesto'] as num).toDouble(),
          trabajadorId: data['trabajadorId'] as String?,
          categoria: data['categoria'] as String,
          fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
        );
      }).toList();

      emit(SolicitudesLoaded(solicitudes: solicitudes, filtroActual: event.status));
    });

    on<UpdateSolicitud>((event, emit) {
      // TODO: implement event handler

      emit((state as SolicitudesLoaded).copyWith(
              solicitudes: (state as SolicitudesLoaded).solicitudes.map((solicitud) {
                if (solicitud.id == event.solicitud.id) {
                  return event.solicitud;
                }
                return solicitud;
              }).toList(),
            )
          );
    });
  }
}
