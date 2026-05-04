import 'package:formz/formz.dart';

enum PresupuestoError { empty, invalid, tooLow }
class PresupuestoInput extends FormzInput<double, PresupuestoError> {
  const PresupuestoInput.pure({double value = 0}) : super.pure(value);
  const PresupuestoInput.dirty({double value = 0}) : super.dirty(value);

  @override
  PresupuestoError? validator(double value) {
    if (value.toString().isEmpty) return PresupuestoError.empty;

    if (value <= 0) return PresupuestoError.tooLow;

    return null;
  }
}