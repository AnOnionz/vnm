import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fms/features/urgency/domain/usecases/begin_urgency_usecase.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/urgency_entity.dart';
import '../../domain/usecases/end_urgency_usecase.dart';

part 'urgency_state.dart';

class UrgencyCubit extends Cubit<UrgencyState> {
  final BeginUrgencyUsecase _beginUrgencyUsecase;
  final EndUrgencyUsecase _endUrgencyUsecase;
  UrgencyCubit(this._beginUrgencyUsecase, this._endUrgencyUsecase)
      : super(UrgencyInitial());

  Future<void> beginUrgency(
      {required int featureId,
      required int featureUrgencyId,
      String? note}) async {
    emit(UrgencyLoading());
    final excute = await _beginUrgencyUsecase(BeginUrgencyParmas(
        featureId: featureId, featureUrgencyId: featureUrgencyId, note: note));
    excute.fold((failure) {
      emit(UrgencyBeginFailure(
          failure: failure, featureUrgencyId: featureUrgencyId, note: note));
    }, (urgency) {
      emit(UrgencyBegan(urgency: urgency!));
    });
  }

  Future<void> endUrgency({required int featureId}) async {
    emit(UrgencyLoading());
    final excute = await _endUrgencyUsecase(featureId);
    excute.fold((failure) {
      emit(UrgencyEndFailure(failure: failure));
    }, (urgency) {
      emit(UrgencyEnded());
    });
  }
}
