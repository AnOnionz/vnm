import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/profile/data/repositories/profile_repository_impl.dart';

import '../entities/profile_status_entity.dart';

class GetProfileStatusUsecase extends UseCase<ProfileStatusEntity?, void> {
  final ProfileRepositoryImpl _repository;

  GetProfileStatusUsecase(this._repository);
  @override
  Future<Result<ProfileStatusEntity?>> call([void params]) async {
    return _repository.getProfileStatus();
  }
}
