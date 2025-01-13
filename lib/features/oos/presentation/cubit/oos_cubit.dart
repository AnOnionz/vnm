import 'package:bloc/bloc.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';
import 'package:fms/features/oos/domain/usecases/create_oos_usecase.dart';

part 'oos_state.dart';

class OosCubit extends Cubit<OosState> {
  final CreateOosUsecase createOos;

  OosCubit(this.createOos) : super(OosInitial());

  Future<void> saveData(
      {required OOSEntity entity, required FeatureEntity feature}) async {
    emit(OosLoading());
    final execute =
        await createOos(CreateOosParams(entity: entity, feature: feature));
    execute.fold((failure) {
      emit(OosFailure(failure));
    }, (data) async {
      emit(OosSuccess(data!));
    });
  }
}
