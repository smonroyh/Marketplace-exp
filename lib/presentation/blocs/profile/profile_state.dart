part of 'profile_bloc.dart';

class ProfileState extends Equatable {

  final Usuario? usuario;
  final FormzSubmissionStatus status;


  const ProfileState({this.usuario, this.status= FormzSubmissionStatus.initial});

  ProfileState copyWith({
    Usuario? usuario,
    FormzSubmissionStatus? status
  }){
    return ProfileState(
      usuario: usuario ?? this.usuario,
      status: status ?? this.status
    );
  }
  
  @override
  List<Object> get props => [?usuario , status];
}

