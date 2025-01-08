import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../urgency/domain/entities/urgency_entity.dart';
import '../../domain/usecases/get_urgency_team_usecase.dart';

part 'urgency_team_event.dart';
part 'urgency_team_state.dart';

class UrgencyTeamBloc extends Bloc<UrgencyTeamEvent, UrgencyTeamState> {
  final GetUrgencyTeamUsecase _getUrgencyTeamUsecase;
  UrgencyTeamBloc(this._getUrgencyTeamUsecase) : super(UrgencyTeamInitial()) {
    on<FetchUrgencyTeam>((event, emit) async {
      emit(UrgencyTeamLoading());
      final execute = await _getUrgencyTeamUsecase(event.featureId);
      execute.fold((failure) {
        emit(UrgencyTeamFailure(failure: failure));
      }, (data) {
        emit(UrgencyTeamSuccess(urgencies: data));
      });
    });
  }
}
