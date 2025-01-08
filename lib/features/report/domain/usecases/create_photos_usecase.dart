import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/report/data/repositories/report_repository_impl.dart';

import '../entities/photo_entity.dart';

class CreatePhotosUsecase
    extends UseCase<List<PhotoEntity>, CreatePhotosParams> {
  final ReportRepositoryImpl repository;

  CreatePhotosUsecase(this.repository);
  @override
  Future<Result<List<PhotoEntity>>> call(CreatePhotosParams params) async {
    return repository
        .createPhotos(photos: params.photos, feature: params.feature)
        .withLoading();
  }
}

class CreatePhotosParams {
  final List<PhotoEntity> photos;

  final FeatureEntity feature;

  CreatePhotosParams({required this.photos, required this.feature});
}
