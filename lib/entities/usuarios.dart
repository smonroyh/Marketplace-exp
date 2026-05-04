import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:push_app/presentation/blocs/auth/auth_state.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String fotoUrl;
  final String telefono;
  final UserRole role;

  // Solo para trabajadores

  final double experiencia;
  final bool disponibilidad;
  final double rating;
  final List<String> oficios; 

  Usuario({
    required this.uid,
    required this.nombre,
    this.fotoUrl = '',
    required this.email,
    required this.role,
    required this.telefono,

    this.experiencia = 0.0,
    this.disponibilidad = true,
    this.rating = 0.0,
    this.oficios = const [],
  });

  copyWith({
    String? uid,
    String? nombre,
    String? fotoUrl,
    String? email,
    UserRole? role,
    String? telefono,

    double? experiencia,
    bool? disponibilidad,
    double? rating,
    List<String>? oficios,
  }){
    return Usuario(
    uid: uid ?? this.uid, 
    nombre: nombre ?? this.nombre, 
    email: email ?? this.email, 
    role: role ?? this.role, 
    telefono: telefono ?? this.telefono,


    experiencia: experiencia ?? this.experiencia,
    disponibilidad: disponibilidad ?? this.disponibilidad,
    fotoUrl: fotoUrl ?? this.fotoUrl,
    oficios: oficios ?? this.oficios,
    rating: rating ?? this.rating
    );
  }

  

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario(
      uid: doc.id,
      nombre: data['nombre'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      oficios: List<String>.from(data['oficios'] ?? []),
      email: data["email"] ?? '',
      role: data["rol"] == 'trabajador' ? UserRole.trabajador : UserRole.cliente,
      telefono: data["telefono"] ?? "sin telefono",
      disponibilidad: data["disponibilidad"],
      experiencia: (data['experiencia'] ?? 0.0).toDouble(),
    );
  }
}