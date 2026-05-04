part of 'worker_feed_bloc.dart';

class WorkerFeedState extends Equatable {
  final List<Solicitud> solicitudes;
  final FormzSubmissionStatus status;
  final String? selectedCategory;

  const WorkerFeedState({
    this.solicitudes = const [],
    this.status = FormzSubmissionStatus.initial,
    this.selectedCategory,
  });

  WorkerFeedState copyWith({
    List<Solicitud>? solicitudes,
    FormzSubmissionStatus? status,
    String? selectedCategory,
  }) {
    return WorkerFeedState(
      solicitudes: solicitudes ?? this.solicitudes,
      status: status ?? this.status,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
  
  @override
  List<Object> get props => [solicitudes, status, selectedCategory ?? ''];
}

final class WorkerFeedInitial extends WorkerFeedState {}
