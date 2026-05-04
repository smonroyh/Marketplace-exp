part of 'form_need_bloc.dart';


class FormNeedState extends Equatable {
  final TituloInput titulo;
  final DescripcionInput descripcion;
  final CategoriaInput categoria;
  final bool isValid;
  final FormzSubmissionStatus status;
  final PresupuestoInput presupuesto;



  const FormNeedState({
    this.titulo = const TituloInput.pure(),
    this.descripcion = const DescripcionInput.pure(),
    this.categoria = const CategoriaInput.pure(),
    this.isValid = false,
    this.presupuesto = const PresupuestoInput.pure(),
    this.status = FormzSubmissionStatus.initial
  });

  FormNeedState copyWith({
    TituloInput? titulo,
    DescripcionInput? descripcion,
    CategoriaInput? categoria,
    PresupuestoInput? presupuesto,
    FormzSubmissionStatus? status,
    bool? isValid
  }) {
    return FormNeedState(
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      presupuesto: presupuesto ?? this.presupuesto,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid
    );
  }

  @override
  List<Object?> get props => [titulo, descripcion, categoria,isValid,status,presupuesto];
}


