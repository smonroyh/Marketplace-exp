import 'package:formz/formz.dart';

class DescripcionInput extends FormzInput<String, String> {
  const DescripcionInput.pure() : super.pure(''); 
  const DescripcionInput.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) => value.isEmpty ? 'Obligatorio' : null;
}