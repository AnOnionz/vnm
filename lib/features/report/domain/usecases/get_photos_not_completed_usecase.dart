import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/report/data/repositories/report_repository_impl.dart';

class GetPhotosNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  final ReportRepositoryImpl repository;

  GetPhotosNotCompletedUsecase(this.repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return repository.getPhotosNotCompleted(feature: params);
  }
}
