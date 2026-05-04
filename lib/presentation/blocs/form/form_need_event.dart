part of 'form_need_bloc.dart';

sealed class FormNeedEvent extends Equatable {
  const FormNeedEvent();
  @override
  List<Object?> get props => [];
}

class TitleChanged extends FormNeedEvent {
  final String value;
  const TitleChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class DescriptionChanged extends FormNeedEvent {
  final String value;
  const DescriptionChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class CategoriaChanged extends FormNeedEvent {
  final String value;
  const CategoriaChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class PresupuestoChanged extends FormNeedEvent {
  final double value;
  const PresupuestoChanged(this.value);
  @override
  List<Object?> get props => [value];
}


class FormNeedSubmitted extends FormNeedEvent{
}
