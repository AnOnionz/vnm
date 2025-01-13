import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/features/urgency/domain/entities/urgency_entity.dart';
import 'package:fms/features/urgency/domain/usecases/current_urgency_usecase.dart';

part 'current_urgency_state.dart';

class CurrentUrgencyCubit extends Cubit<CurrentUrgencyState> {
  final CurrentUrgencyUsecase _currentUrgencyUsecase;
  CurrentUrgencyCubit(this._currentUrgencyUsecase)
      : super(CurrentUrgencyInitial());

  Future<void> getCurrentUrgency(int featureId) async {
    emit(CurrentUrgencyLoading());
    final excute = await _currentUrgencyUsecase(featureId);
    excute.fold((failure) {
      emit(CurrentUrgencyFailure(failure: failure));
    }, (urgency) {
      emit(CurrentUrgencySuccess(urgency: urgency));
    });
  }
}
