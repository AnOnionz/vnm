part of 'urgency_team_bloc.dart';

abstract class UrgencyTeamEvent extends Equatable {
  const UrgencyTeamEvent();

  @override
  List<Object> get props => [];
}

class FetchUrgencyTeam extends UrgencyTeamEvent {
  final int featureId;

  FetchUrgencyTeam({required this.featureId});
}
