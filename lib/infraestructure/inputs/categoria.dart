import 'package:formz/formz.dart';

class CategoriaInput extends FormzInput<String, String> {
  const CategoriaInput.pure([String value = 'Plomería']) : super.pure(value);
  const CategoriaInput.dirty([String value = 'Plomería']) : super.dirty(value);
  @override
  String? validator(String value) => value.isEmpty ? 'Selecciona categoría' : null;
}