part of 'postulacion_oferta_bloc.dart';

class PostulacionOfertaState extends Equatable {
  final MontoInput monto;
  final String mensaje;
  final FormzSubmissionStatus status;
  final Usuario? usuario;
  final String? errorMessage;
  final bool alreadySent;

  const PostulacionOfertaState({
    this.monto = const MontoInput.pure(value: 0),
    this.mensaje = '',
    this.status = FormzSubmissionStatus.initial,
    this.usuario ,
    this.errorMessage,
    this.alreadySent = false
  });

  PostulacionOfertaState copyWith({
    double? monto, 
    String? mensaje, 
    FormzSubmissionStatus? status, 
    String? errorMessage, 
    Usuario? usuario,
    bool? alreadySent}) {
    return PostulacionOfertaState(
      monto: monto != null ? MontoInput.dirty(value: monto) : this.monto,
      mensaje: mensaje ?? this.mensaje,
      status: status ?? this.status,
      errorMessage: errorMessage,
      usuario: usuario ?? this.usuario,
      alreadySent: alreadySent ?? this.alreadySent
    );
  }

  @override List<Object?> get props => [monto, mensaje, status, errorMessage, usuario];
}

// final class PostulacionOfertaInitial extends PostulacionOfertaState {}
