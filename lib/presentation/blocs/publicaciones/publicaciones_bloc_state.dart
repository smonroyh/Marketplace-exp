part of 'publicaciones_bloc_bloc.dart';

sealed class PublicacionesBlocState extends Equatable {
  const PublicacionesBlocState();
  
  @override
  List<Object> get props => [];
}

final class PublicacionesLoading extends PublicacionesBlocState {}


final class PublicacionesLoaded extends PublicacionesBlocState {
  final List<Publicacion> publicaciones; // Example property
  const PublicacionesLoaded({required this.publicaciones});

  copyWith({List<Publicacion>? publicaciones}) {
    return PublicacionesLoaded(
      publicaciones: publicaciones ?? this.publicaciones,
    );
  }

  @override
  List<Object> get props => [publicaciones];
}

