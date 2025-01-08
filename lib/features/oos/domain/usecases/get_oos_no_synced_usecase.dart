import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/data_entity.dart';
import 'package:vnm/features/oos/data/repositories/oos_repository_impl.dart';

class GetOosNoSyncedDataUsecase
    extends UseCase<Map<int, List<BaseEntity>>, void> {
  final OosRepositoryImpl _repository;

  GetOosNoSyncedDataUsecase(this._repository);
  @override
  Future<Result<Map<int, List<BaseEntity>>>> call([void params]) async {
    return await _repository.noSyncedData();
  }
}
