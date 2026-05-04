part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}


class LoadProfile extends ProfileEvent{
  final String uid;
  const LoadProfile({required this.uid});


  @override List<Object> get props => [uid];

}
