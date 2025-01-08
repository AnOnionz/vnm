import 'package:bloc/bloc.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';

import '../../../report/domain/entities/photo_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/create_notes_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final CreateNotesUsecase createNotes;
  final GetNotesUsecase getNotes;
  NoteCubit(this.createNotes, this.getNotes) : super(NoteLoading());

  Future<void> saveNotes(
      {required List<NoteEntity> notes,
      required List<PhotoEntity> photos,
      required FeatureEntity feature}) async {
    final execute = await createNotes(
        CreateNotesParams(notes: notes, photos: photos, feature: feature));
    execute.fold((failure) {
      showSuccess(title: 'Lưu thành công');
    }, (data) async {
      await getNotes(feature)
        ..fold((failure) async => emit(NoteSuccess(([], []))),
            (data) async => emit(NoteSuccess(data)));

      showSuccess(title: 'Lưu thành công');
    });
  }

  Future<void> fetchNotes(
      {required GeneralEntity general, required FeatureEntity feature}) async {
    emit(NoteLoading());
    final execute = await getNotes(feature);
    execute.fold((failure) async => emit(NoteFailure(failure)),
        (data) async => emit(NoteSuccess(data)));
  }
}
