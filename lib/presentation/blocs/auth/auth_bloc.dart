import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc() : super(const AuthState()) {
    // Suscribirse a cambios de autenticación
    _authStateSubscription = _auth.authStateChanges().listen((user) {
      add(AuthStateChanged(user));
    });

    on<AuthStateChanged>((event, emit) async {
      if (event.user != null) {
        UserRole? role = state.selectedRole;
        bool profileCompleted = false;
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(event.user!.uid).get();
          final data = doc.data();
          if (data != null) {
            final rolString = data['rol'] as String?;
            if (rolString != null) {
              role = rolString == 'cliente' ? UserRole.cliente : UserRole.trabajador;
            }
            profileCompleted = data['profileCompleted'] == true;
          }
        } catch (_) {}
        emit(state.copyWith(
          userId: event.user!.uid,
          status: FormzSubmissionStatus.success,
          errorMessage: null,
          selectedRole: role,
          profileCompleted: profileCompleted,
          flowStep: profileCompleted ? AuthFlowStep.home : AuthFlowStep.profileSetup,
        ));
      } else {
        emit(const AuthState());
      }
    });
    on<AuthEmailChanged>((event, emit) {
      if(event.email.isEmpty) emit(state.copyWith(emailController: TextEditingController(text: "")));
      emit(state.copyWith(email: event.email, errorMessage: null));
    });
    on<AuthPasswordChanged>((event, emit) {
      if(event.password.isEmpty) emit(state.copyWith(passwordController: TextEditingController(text: "")));
      emit(state.copyWith(password: event.password, errorMessage: null));
    });
    on<AuthLoginSubmitted>((event, emit) async {
      // emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null, isLoading: true));
      try {
        final userCred = await _auth.signInWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password.trim(),
        );
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          userId: userCred.user?.uid,
          errorMessage: null,
          isLoading: false,
        ));
        add(AuthProfileStatusRequested());
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ));
      }
    });
    on<AuthRegisterSubmitted>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress, errorMessage: null, isLoading: true));
      try {
        // Crear usuario en Firebase Auth
        final userCred = await _auth.createUserWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password.trim(),
        );
        
        final userId = userCred.user?.uid;
        if (userId != null && state.selectedRole != null) {

          final userData =<String,dynamic>  {
            'email': state.email.trim(),
            'rol': state.selectedRole == UserRole.cliente ? 'cliente' : 'trabajador',
            'createdAt': FieldValue.serverTimestamp(),
            'profileCompleted': false,
          };

          if(state.selectedRole == UserRole.trabajador){
            userData["ratingTrabajador"]  = 0;
            userData["fotoTrabajadorUrl"] = "https://static.vecteezy.com/system/resources/previews/014/194/232/non_2x/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg";

          }

          // Guardar rol en Firestore
          await FirebaseFirestore.instance.collection('users').doc(userId).set(userData);
        }
        
        emit(state.copyWith(
          status: FormzSubmissionStatus.success,
          userId: userId,
          errorMessage: null,
          isLoading: false,
          profileCompleted: false,
          flowStep: AuthFlowStep.profileSetup,
        ));
        add(AuthProfileStatusRequested());
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
          isLoading: false,
        ));
      }
    });
    on<AuthLogoutRequested>((event, emit) async {
      await _auth.signOut();
      emit(const AuthState());
    });
    on<ShowLoginForm>((event, emit) {
      emit(state.copyWith(flowStep: AuthFlowStep.loginForm, errorMessage: null));
    });
    on<ShowRegisterOptions>((event, emit) {
      emit(state.copyWith(flowStep: AuthFlowStep.selectingRole, errorMessage: null));
    });
    
    on<SelectUserRole>((event, emit) {
      emit(state.copyWith(
        selectedRole: event.role,
        flowStep: AuthFlowStep.registerForm,
        errorMessage: null,
      ));
    });
    on<GoBackToInitial>((event, emit) {
      emit(const AuthState());
    });

    on<AuthProfileStatusRequested>((event, emit) async {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;
      UserRole? role = state.selectedRole;
      bool profileCompleted = state.profileCompleted;
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        final data = doc.data();
        if (data != null) {
          final rolString = data['rol'] as String?;
          if (rolString != null) {
            role = rolString == 'cliente' ? UserRole.cliente : UserRole.trabajador;
          }
          profileCompleted = data['profileCompleted'] == true;
        }
      } catch (_) {}
      emit(state.copyWith(
        selectedRole: role,
        profileCompleted: profileCompleted,
        flowStep: profileCompleted ? AuthFlowStep.home : AuthFlowStep.profileSetup,
      ));
    });

    on<IsNavigatingToProfileChanged>((event, emit) {
      emit(state.copyWith(isNavigatingToProfile: event.value));
    });
  }

  

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
