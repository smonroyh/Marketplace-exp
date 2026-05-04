import 'package:formz/formz.dart';

enum MontoError { empty, invalid }
class MontoInput extends FormzInput<double, MontoError> {
  const MontoInput.pure({double value = 0}) : super.pure(value);
  const MontoInput.dirty({double value = 0}) : super.dirty(value);

  @override
  MontoError? validator(double value) {
    if (value <= 0) return MontoError.invalid;
    return null;
  }
}