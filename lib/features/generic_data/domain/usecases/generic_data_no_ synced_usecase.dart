import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/generic_data/data/repositories/generic_data_repository_impl.dart';

import '../../../general/domain/entities/data_entity.dart';

class GetGenericDataNoSyncedDataUsecase
    extends UseCase<Map<int, List<BaseEntity>>, void> {
  final GenericDataRepositoryImpl _repository;

  GetGenericDataNoSyncedDataUsecase(this._repository);
  @override
  Future<Result<Map<int, List<BaseEntity>>>> call([void params]) async {
    return await _repository.noSyncedData();
  }
}
