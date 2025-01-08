part of 'current_urgency_cubit.dart';

sealed class CurrentUrgencyState extends Equatable {
  const CurrentUrgencyState();

  @override
  List<Object> get props => [];
}

final class CurrentUrgencyInitial extends CurrentUrgencyState {}

final class CurrentUrgencyLoading extends CurrentUrgencyState {}

final class CurrentUrgencySuccess extends CurrentUrgencyState {
  final UrgencyEntity? urgency;

  CurrentUrgencySuccess({required this.urgency});
}

final class CurrentUrgencyFailure extends CurrentUrgencyState {
  final Failure failure;

  CurrentUrgencyFailure({required this.failure});
}
