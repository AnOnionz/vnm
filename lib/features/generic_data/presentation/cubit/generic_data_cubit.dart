import 'package:bloc/bloc.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/core/widgets/popup.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:fms/features/generic_data/domain/usecases/create_generic_data_usecase.dart';
import 'package:fms/features/generic_data/domain/usecases/get_generic_data_usecase.dart';

part 'generic_data_state.dart';

class GenericDataCubit extends Cubit<GenericDataState> {
  final CreateGenericDataUsecase _createGenericData;
  final GetGenericDataUsecase _getGenericData;
  GenericDataCubit(this._createGenericData, this._getGenericData)
      : super(GenericDataLoading());

  Future<void> saveData(
      {required NumericSheetEntity entity,
      required FeatureEntity feature}) async {
    final execute = await _createGenericData(
        CreateGenericDataParams(entity: entity, feature: feature));

    execute.fold((failure) {
      showSuccess(title: 'Lưu thành công');
    }, (data) async {
      await _getGenericData(feature)
        ..fold((failure) => null, (data) {
          emit(GenericDataSuccess(data));
          showSuccess(title: 'Lưu thành công');
        });
    });
  }

  Future<void> fetchData({required FeatureEntity feature}) async {
    emit(GenericDataLoading());
    final execute = await _getGenericData(feature);
    execute.fold((failure) => emit(GenericDataFailure(failure)),
        (data) => emit(GenericDataSuccess(data)));
  }
}
