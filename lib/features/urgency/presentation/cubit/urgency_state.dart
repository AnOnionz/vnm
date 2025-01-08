part of 'urgency_cubit.dart';

abstract class UrgencyState extends Equatable {
  const UrgencyState();

  @override
  List<Object> get props => [];
}

class UrgencyInitial extends UrgencyState {}

class UrgencyLoading extends UrgencyState {}

class UrgencyBegan extends UrgencyState {
  final UrgencyEntity urgency;

  UrgencyBegan({required this.urgency});
}

class UrgencyEnded extends UrgencyState {
  UrgencyEnded();
}

class UrgencyEndFailure extends UrgencyState {
  final Failure failure;

  UrgencyEndFailure({required this.failure});
}

class UrgencyBeginFailure extends UrgencyState {
  final Failure failure;
  final int featureUrgencyId;
  final String? note;

  UrgencyBeginFailure(
      {required this.failure, required this.featureUrgencyId, this.note});
}
