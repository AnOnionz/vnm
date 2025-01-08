import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/report/data/repositories/report_repository_impl.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';

class GetPhotosUsecase extends UseCase<List<PhotoEntity>, FeatureEntity> {
  final ReportRepositoryImpl repository;

  GetPhotosUsecase(this.repository);
  @override
  Future<Result<List<PhotoEntity>>> call(FeatureEntity params) {
    return repository.allPhotos(feature: params);
  }
}
