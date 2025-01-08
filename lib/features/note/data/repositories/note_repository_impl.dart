import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/constant/mapper.dart';
import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/data_source/local_data_source.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/repository/repository.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';

import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/images/data/datasource/delete_image_local_remote_datasource.dart';
import 'package:vnm/features/images/data/datasource/delete_image_remote_datasource.dart';
import 'package:vnm/features/note/data/datasources/note_local_datasource.dart';

import 'package:vnm/features/note/domain/entities/note_entity.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/usecase/either.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';

class NoteRepositoryImpl extends Repository
    with GeneralDataMixin, LocalDatasource
    implements NoteRepository {
  final NoteLocalDataSource _local;
  final NoteRemoteDataSource _remote;
  final DeletePhotoRemoteDataSource _remotePhoto;
  final DeletePhotoLocalDataSource _localPhoto;

  NoteRepositoryImpl(
      this._local, this._remote, this._remotePhoto, this._localPhoto);
  @override
  Future<Result<(List<NoteEntity> notes, List<PhotoEntity> photos)>> allNotes(
      {required FeatureEntity feature}) async {
    return todo(() async {
      List<NoteEntity> notes;
      List<PhotoEntity> photos;

      notes = await _local.getNotesByFeature(feature);

      if (notes.isNotEmpty) {
        photos = notes
            .map((note) => note.photos)
            .expand((element) => element)
            .toList();
        return Right((notes, photos));
      }
      notes = await _remote.allNotes(general: general!, feature: feature);
      photos = await _remote.allPhotos(general: general!, feature: feature);

      return Right((notes, photos));
    });
  }

  @override
  Future<Result<void>> createNotes(
      {required List<NoteEntity> notes,
      required List<PhotoEntity> photos,
      required FeatureEntity feature}) async {
    return todo(
      () async {
        final notesCached =
            await _cacheNotes(notes: notes, photos: photos, feature: feature);
        await _uploadNotes(notes: notesCached, feature: feature);
        return Right(Never);
      },
    );
  }

  @override
  Future<Result<FeatureEntity?>> getNotesNotCompleted(
      {required FeatureEntity feature}) {
    return todo(() async {
      final localNotes = await _local.getNotesByFeature(feature);

      final featureMultimedias = <FeatureMultimedia>[];

      feature.featureMultimedias!.forEach((featureMultimedia) {
        final note = localNotes.firstWhereOrNull(
            (element) => element.featureMultimediaId == featureMultimedia.id);

        final bool isTextEmpty = featureMultimedia.isTextFieldRequired! &&
            ((note != null && note.value.isEmptyOrNull) || note == null);
        final bool isPhotoEmpty = featureMultimedia.minimumImages! > 0 &&
            ((note != null &&
                    note.photos
                            .where((element) =>
                                element.status != SyncStatus.isDeleted)
                            .length <
                        featureMultimedia.minimumImages!) ||
                note == null);

        if (isTextEmpty || isPhotoEmpty) {
          featureMultimedias.add(featureMultimedia);
        }
      });
      if (featureMultimedias.length > 0) {
        return Right(feature.copyWith(featureMultimedias: featureMultimedias));
      }

      return Right(null);
    });
  }

  @override
  Future<Result<Map<int, List<NoteEntity>>>> noSyncedData() async {
    return todo(() async {
      final localNotes = await _local.getNotes();

      final map = localNotes.groupListsBy((element) => element.featureId!);
      map.entries.forEach(
        (element) {
          element.value
              .removeWhere((element) => element.status == SyncStatus.synced);
        },
      );
      return Right(map);
    });
  }

  @override
  Future<void> synchronized(FeatureEntity feature) async {
    final notesNoSynced = await _local.getNotesNoSynced(feature);
    await _uploadNotes(notes: notesNoSynced, feature: feature);
  }

  Future<List<NoteEntity>> _cacheNotes(
      {required List<NoteEntity> notes,
      required List<PhotoEntity> photos,
      required FeatureEntity feature}) async {
    final List<NoteEntity> newNotes = [];
    photos.forEach((photo) {
      photo = photo.copyWith(
          featureId: feature.id, attendanceId: general!.attendance!.id);
      _local.cachePhotoToLocal(photo);
    });
    await Future.forEach(notes, (note) async {
      final photosOfNote = photos
          .where((photo) => photo.featurePhotoId == note.featureMultimediaId);

      final time = await Modular.get<NetworkTimeService>().ntpDateTime();
      final newNote = note.copyWith(
          dataUuid: Uuid().v1(),
          dataTimestamp: time,
          featureId: feature.id,
          value: Value(object: note.value),
          attendanceId: general!.attendance!.id);
      _local.cacheNoteToLocal(newNote);
      newNote.photos.addAll(photosOfNote);
      db.writeTxnSync(() => newNote.photos.saveSync());
      newNotes.add(newNote);
    });
    return newNotes;
  }

  Future<void> _uploadNotes(
      {required List<NoteEntity> notes, required FeatureEntity feature}) async {
    await Future.forEach(notes, (note) async {
      NoteEntity? report;

      Future<void> postPhoto(PhotoEntity photo) async {
        final resp = await _remote.createPhoto(
            photo: photo, general: general!, feature: feature);

        if (resp != null) {
          _local.cachePhotoToLocal(photo.copyWith(
              id: resp.id, image: resp.image, status: SyncStatus.synced));
        }
      }

      if (note.status == SyncStatus.isNoSynced) {
        if (note.photos.isNotEmpty) {
          final photos = note.photos.toList().sortedByCompare(
                (element) => element.status,
                (a, b) => b.index.compareTo(a.index),
              );

          await Future.forEach(
              photos.where((photo) => photo.status == SyncStatus.isDeleted),
              (photo) async {
            if (photo.image != null) {
              await _remotePhoto.deleteNotePhoto(
                  general: general!, feature: feature, id: photo.id!);
            }
            _localPhoto.deleteLocalPhoto(id: photo.isarId);
          });

          await Future.wait(photos
              .where((element) => element.status == SyncStatus.isNoSynced)
              .slices(2)
              .map((uploadImageTasks) => Future.delayed(
                  1.seconds,
                  () =>
                      Future.wait(uploadImageTasks.map((e) => postPhoto(e))))));
        }
        if (!note.value.isEmptyOrNull || (!note.isTextFieldRequired)) {
          report = await _remote.createNote(note: note, general: general!);
        }
      }

      _local.cacheNoteToLocal(
          note.copyWith(id: report?.id, status: SyncStatus.synced));
    });
  }
}
