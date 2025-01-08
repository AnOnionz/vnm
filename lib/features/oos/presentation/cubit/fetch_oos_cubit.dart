import 'package:bloc/bloc.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/oos/domain/entities/oos_entity.dart';
import 'package:vnm/features/oos/domain/usecases/get_current_oos_usecase.dart';

part 'fetch_oos_state.dart';

class FetchOosCubit extends Cubit<FetchOosState> {
  final GetCurrentOosUsecase getCurrentOos;
  FetchOosCubit(this.getCurrentOos) : super(FetchOosInitial());

  Future<void> fetchData({required FeatureEntity feature}) async {
    emit(FetchOosLoading());
    final execute = await getCurrentOos(feature);
    execute.fold((failure) => emit(FetchOosFailure(failure)),
        (data) => emit(FetchOosSuccess(data)));
  }
}
