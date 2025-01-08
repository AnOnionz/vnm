import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/sampling/domain/entities/sampling_entity.dart';
import 'package:vnm/features/sampling/domain/usecases/get_samplings_usecase.dart';

part 'get_samplings_state.dart';

class GetSamplingsCubit extends Cubit<GetSamplingsState> {
  final GetSamplingUsecase _getSampling;
  GetSamplingsCubit(this._getSampling) : super(GetSamplingsInitial());

  Future<void> getSamplings(GeneralFeatureData data) async {
    emit(GetSamplingsLoading());
    await _getSampling(GetSamplingParmas(
        attendanceId: data.general.attendance!.id!,
        featureId: data.feature.id!))
      ..fold((failure) => emit(GetSamplingsFailure(failure)),
          (data) => emit(GetSamplingsSuccess(entity: data)));
  }
}
