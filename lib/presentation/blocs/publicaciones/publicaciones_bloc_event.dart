part of 'publicaciones_bloc_bloc.dart';

sealed class PublicacionesBlocEvent extends Equatable {
  const PublicacionesBlocEvent();

  @override
  List<Object> get props => [];
}

// final class LoadingPublicacionesRequested extends PublicacionesBlocEvent {}


final class LoadedPublicacionesRequested extends PublicacionesBlocEvent {

  // final List<Publicacion> publicaciones;
  // const LoadedPublicacionesRequested(this.publicaciones);
}

final class FilterPublicacionesChanged extends PublicacionesBlocEvent {}
