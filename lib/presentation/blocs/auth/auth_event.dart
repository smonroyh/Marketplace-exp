import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthEmailChanged extends AuthEvent {
  final String email;
  AuthEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  AuthPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class AuthLoginSubmitted extends AuthEvent {}

class AuthRegisterSubmitted extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class ShowLoginForm extends AuthEvent {}

class ShowRegisterOptions extends AuthEvent {}

class SelectUserRole extends AuthEvent {
  final UserRole role;
  SelectUserRole(this.role);
  @override
  List<Object?> get props => [role];
}

class GoBackToInitial extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final User? user;
  AuthStateChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class IsNavigatingToProfileChanged extends AuthEvent{
  final bool value;
  IsNavigatingToProfileChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class AuthProfileStatusRequested extends AuthEvent {}
