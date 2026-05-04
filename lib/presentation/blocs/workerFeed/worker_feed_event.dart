part of 'worker_feed_bloc.dart';

sealed class WorkerFeedEvent extends Equatable {
  const WorkerFeedEvent();

  @override
  List<Object> get props => [];
}

final class WorkerSubscriptionRequested extends WorkerFeedEvent {
  final List<String> misCategorias;

  const WorkerSubscriptionRequested({required this.misCategorias});

  @override
  List<Object> get props => [misCategorias];
}
