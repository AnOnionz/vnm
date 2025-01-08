import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/note/data/repositories/note_repository_impl.dart';
import 'package:vnm/features/note/domain/entities/note_entity.dart';

import '../../../report/domain/entities/photo_entity.dart';

class GetNotesUsecase extends UseCase<
    (List<NoteEntity> notes, List<PhotoEntity> photos), FeatureEntity> {
  final NoteRepositoryImpl repository;

  GetNotesUsecase(this.repository);
  @override
  Future<Result<(List<NoteEntity> notes, List<PhotoEntity> photos)>> call(
      FeatureEntity params) {
    return repository.allNotes(feature: params);
  }
}
