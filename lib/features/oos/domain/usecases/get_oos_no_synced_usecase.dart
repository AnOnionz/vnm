import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/data_entity.dart';
import 'package:fms/features/oos/data/repositories/oos_repository_impl.dart';

class GetOosNoSyncedDataUsecase
    extends UseCase<Map<int, List<BaseEntity>>, void> {
  final OosRepositoryImpl _repository;

  GetOosNoSyncedDataUsecase(this._repository);
  @override
  Future<Result<Map<int, List<BaseEntity>>>> call([void params]) async {
    return await _repository.noSyncedData();
  }
}
