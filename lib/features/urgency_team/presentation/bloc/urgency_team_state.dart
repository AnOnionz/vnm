part of 'urgency_team_bloc.dart';

abstract class UrgencyTeamState extends Equatable {
  const UrgencyTeamState();

  @override
  List<Object> get props => [];
}

class UrgencyTeamInitial extends UrgencyTeamState {}

class UrgencyTeamLoading extends UrgencyTeamState {}

class UrgencyTeamSuccess extends UrgencyTeamState {
  final List<UrgencyEntity> urgencies;

  UrgencyTeamSuccess({required this.urgencies});
}

class UrgencyTeamFailure extends UrgencyTeamState {
  final Failure failure;

  UrgencyTeamFailure({required this.failure});
}
