import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:push_app/entities/ofertas.dart';
import 'package:push_app/entities/solicitudes.dart';
import 'package:push_app/presentation/blocs/solicitudes.dart/solicitudes_bloc.dart';

part 'solicitud_detalle_state.dart';

class SolicitudDetalleCubit extends Cubit<SolicitudDetalleState> {
  final SolicitudesBloc solicitudesBloc;

  SolicitudDetalleCubit({
    required String solicitudId,
    required this.solicitudesBloc,
  }) : super(SolicitudDetalleInitial());

  Future<void> loadSolicitudDetail(String id) async {
    // En un caso real, esto emitiría SolicitudesLoading y luego SolicitudesLoaded
    emit(SolicitudDetalleLoading());

    try {
      final snapSoli = await FirebaseFirestore.instance
          .collection('solicitudes')
          .doc(id)
          .get();

      final data = snapSoli.data();

      final snapOferta = await FirebaseFirestore.instance
          .collection('solicitudes')
          .doc(id)
          .collection("ofertas")
          .get();

      final ofertas = snapOferta.docs.map((doc) {
        final ofertaData = doc.data();
        return Oferta(
          id: doc.id,
          trabajadorId: ofertaData['trabajadorId'] as String,
          nombreTrabajador: ofertaData['nombreTrabajador'] as String,
          monto: (ofertaData['monto'] as num).toDouble(),
          mensaje: ofertaData['mensaje'] as String,
          ratingTrabajador: (ofertaData['ratingTrabajador'] as num).toDouble(),
          fechaCreacion: (ofertaData['fechaOferta'] as Timestamp).toDate(),
          fotoTrabajadorUrl: ofertaData['fotoTrabajadorUrl'] as String,
        );
      }).toList();

      late Solicitud solicitud;

      if (data != null) {
        solicitud = Solicitud(
          id: snapSoli.id,
          clienteId: data['clienteId'] as String,
          titulo: data['titulo'] as String,
          detalles: data['detalles'] as String,
          status: SolicitudStatus.values.firstWhere(
            (e) => e.name == (data['status'] as String),
            orElse: () => SolicitudStatus.pendiente,
          ),
          trabajadorId: data['trabajadorId'] as String?,
          presupuesto: (data['presupuesto'] as num).toDouble(),
          categoria: data['categoria'] as String,
          fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
          
          nombreTrabajador: data['nombreTrabajador'] as String?,
          fotoTrabajadorUrl: data['fotoTrabajadorUrl'] as String?,
          ratingTrabajador: (data['ratingTrabajador'] as num?)?.toDouble()
        );

        solicitud = solicitud.copywith(ofertas: ofertas);
      }
      emit(SolicitudDetalleLoaded(solicitud: solicitud));
    } catch (e) {
      emit(SolicitudDetalleError(message: e.toString()));
    }
  }

  Future<void> solicitudOfferedAccepted(String id, Oferta oferta) async {
    try {
      await FirebaseFirestore.instance.collection('solicitudes').doc(id).update({
        'status': 'activa',
        'trabajadorId': oferta.trabajadorId,
        "fotoTrabajadorUrl": oferta.fotoTrabajadorUrl,
        "nombreTrabajador": oferta.nombreTrabajador,
        "ratingTrabajador": oferta.ratingTrabajador,
      });

      if (state is SolicitudDetalleLoaded) {
        final solicitudActualizada = (state as SolicitudDetalleLoaded).solicitud.copywith(
          status: SolicitudStatus.activa,
          trabajadorId: oferta.trabajadorId,
          fotoTrabajadorUrl: oferta.fotoTrabajadorUrl,
          nombreTrabajador: oferta.nombreTrabajador,
          ratingTrabajador: oferta.ratingTrabajador,
        );

        // Actualizar el estado local del detalle
        emit(SolicitudDetalleLoaded(solicitud: solicitudActualizada));

        // Sincronizar con el BLoC de solicitudes
        solicitudesBloc.add(UpdateSolicitud(solicitud: solicitudActualizada));
      }
    } catch (e) {
      emit(SolicitudDetalleError(message: e.toString()));
    }
  }

  Future<void> changeStatusSolicitud(String id, SolicitudStatus status) async {
    try {
      await FirebaseFirestore.instance.collection('solicitudes').doc(id).update({
        'status': status.name,
      });

      if (state is SolicitudDetalleLoaded) {
        final solicitudActualizada = (state as SolicitudDetalleLoaded).solicitud.copywith(
          status: status,
        );

        // Actualizar el estado local del detalle
        emit(SolicitudDetalleLoaded(solicitud: solicitudActualizada));

        // Sincronizar con el BLoC de solicitudes
        solicitudesBloc.add(UpdateSolicitud(solicitud: solicitudActualizada));
      }
    } catch (e) {
      emit(SolicitudDetalleError(message: e.toString()));
    }
  }
}
