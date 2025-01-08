import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/note/data/repositories/note_repository_impl.dart';

class GetNotesNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  final NoteRepositoryImpl repository;

  GetNotesNotCompletedUsecase(this.repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return repository.getNotesNotCompleted(feature: params);
  }
}
