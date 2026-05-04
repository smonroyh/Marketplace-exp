import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

enum AuthFlowStep { initial, selectingRole, loginForm, registerForm, profileSetup, home }
enum UserRole { cliente, trabajador }

class AuthState extends Equatable {
  final String email;
  final String password;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isNavigatingToProfile;
  final FormzSubmissionStatus status;
  final String? errorMessage;
  final String? userId;
  final AuthFlowStep flowStep;
  final UserRole? selectedRole;
  final bool isLoading;
  final bool profileCompleted;

  const AuthState({
    this.email = '',
    this.password = '',
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
    this.userId,
    this.flowStep = AuthFlowStep.initial,
    this.selectedRole,
    this.isLoading = false,
    this.profileCompleted = false,
    this.emailController,
    this.passwordController,
    this.isNavigatingToProfile = false,
  });

  AuthState copyWith({
    String? email,
    String? password,
    FormzSubmissionStatus? status,
    String? errorMessage,
    String? userId,
    AuthFlowStep? flowStep,
    UserRole? selectedRole,
    bool? isLoading,
    bool? profileCompleted,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? isNavigatingToProfile,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
      userId: userId ?? this.userId,
      flowStep: flowStep ?? this.flowStep,
      selectedRole: selectedRole ?? this.selectedRole,
      isLoading: isLoading ?? this.isLoading,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      isNavigatingToProfile: isNavigatingToProfile ?? this.isNavigatingToProfile,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, status, errorMessage, userId, flowStep, selectedRole, isLoading, profileCompleted];
}
