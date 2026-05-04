import 'package:formz/formz.dart';

class TituloInput extends FormzInput<String, String> {
  const TituloInput.pure() : super.pure('');
  const TituloInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) => value.isEmpty ? 'Obligatorio' : null;
}