import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/note/data/repositories/note_repository_impl.dart';
import 'package:vnm/features/note/domain/entities/note_entity.dart';

import '../../../report/domain/entities/photo_entity.dart';

class CreateNotesUsecase extends UseCase<void, CreateNotesParams> {
  final NoteRepositoryImpl repository;

  CreateNotesUsecase(this.repository);
  @override
  Future<Result<void>> call(CreateNotesParams params) async {
    return repository
        .createNotes(
            notes: params.notes, photos: params.photos, feature: params.feature)
        .withLoading();
  }
}

class CreateNotesParams {
  final List<NoteEntity> notes;
  final List<PhotoEntity> photos;
  final FeatureEntity feature;

  CreateNotesParams(
      {required this.notes, required this.photos, required this.feature});
}
