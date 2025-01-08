import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/oos/data/repositories/oos_repository_impl.dart';
import 'package:vnm/features/oos/domain/entities/oos_entity.dart';

class GetCurrentOosUsecase extends UseCase<OOSEntity?, FeatureEntity> {
  final OosRepositoryImpl _repository;

  GetCurrentOosUsecase(this._repository);
  @override
  Future<Result<OOSEntity?>> call(FeatureEntity params) async {
    return _repository.getCurrentOOS(feature: params);
  }
}
