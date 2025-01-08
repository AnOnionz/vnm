import 'dart:async';

import 'package:collection/collection.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/repository/repository.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/images/data/datasource/delete_image_local_remote_datasource.dart';
import 'package:vnm/features/images/data/datasource/delete_image_remote_datasource.dart';
import 'package:vnm/features/report/data/datasources/report_local_datasource.dart';
import 'package:vnm/features/report/data/datasources/report_remote_datasource.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';
import 'package:vnm/features/report/domain/repositories/report_repository.dart';

import '../../../../core/usecase/either.dart';

class ReportRepositoryImpl extends Repository
    with GeneralDataMixin
    implements ReportRepository {
  final ReportRemoteDataSource _remote;
  final ReportLocalDataSource _local;
  final DeletePhotoRemoteDataSource _remotePhoto;
  final DeletePhotoLocalDataSource _localPhoto;

  ReportRepositoryImpl(
      this._remote, this._local, this._remotePhoto, this._localPhoto);
  @override
  Future<Result<List<PhotoEntity>>> allPhotos(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final localPhotos = await _local.getPhotosByFeature(feature);

      if (localPhotos.isNotEmpty) {
        return Right(localPhotos);
      }
      final photos =
          await _remote.allPhotos(general: general!, feature: feature);

      photos.forEach((element) {
        element.attendanceId = general!.attendance!.id;
        element.featureId = feature.id;
        element.status = SyncStatus.synced;
      });
      _local.cachePhotosToLocal(photos);

      return Right(photos);
    });
  }

  @override
  Future<Result<List<PhotoEntity>>> createPhotos(
      {required List<PhotoEntity> photos,
      required FeatureEntity feature}) async {
    return todo(
      () async {
        photos.forEach((element) {
          element.attendanceId = general!.attendance!.id;
          element.featureId = feature.id;
        });
        final _photos = photos.where(
          (photo) {
            if (photo.status == SyncStatus.isDeleted &&
                !_localPhoto.canDeleteLocalPhoto(id: photo.isarId)) {
              return false;
            }
            return true;
          },
        ).toList();
        _local.cachePhotosToLocal(_photos);
        await _uploadReport(photos: _photos, feature: feature);
        final localPhotos = await _local.getPhotosByFeature(feature);
        return Right(localPhotos);
      },
    );
  }

  @override
  Future<Result<FeatureEntity?>> getPhotosNotCompleted(
      {required FeatureEntity feature}) {
    return todo(() async {
      final localPhotos = await _local.getPhotosByFeature(feature);

      final featurePhotos = <FeaturePhoto>[];
      final photoGroup = groupBy<PhotoEntity, int>(
        localPhotos,
        (photo) {
          return photo.featurePhotoId;
        },
      );

      feature.featurePhotos!.forEach((featurePhoto) {
        final photos = (photoGroup[featurePhoto.id!] ?? [])
            .where((element) => element.status != SyncStatus.isDeleted);

        if (featurePhoto.minimum! > 0 &&
            photos.length < featurePhoto.minimum!) {
          featurePhotos.add(featurePhoto);
        }
      });
      if (featurePhotos.length > 0) {
        return Right(feature.copyWith(featurePhotos: featurePhotos));
      }

      return Right(null);
    });
  }

  @override
  Future<Result<Map<int, List<PhotoEntity>>>> noSyncedData() async {
    return todo(() async {
      final localPhotos = await _local.getPhotos();

      final map = localPhotos.groupListsBy((element) => element.featureId!);
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
    final photosNoSynced = await _local.getPhotosNotSynced(feature);
    return await _uploadReport(photos: photosNoSynced, feature: feature);
  }

  Future<void> _uploadReport(
      {required List<PhotoEntity> photos,
      required FeatureEntity feature}) async {
    final _photos = photos.sortedByCompare(
      (element) => element.status,
      (a, b) => b.index.compareTo(a.index),
    );

    Future<void> postPhoto(PhotoEntity photo) async {
      if (photo.status == SyncStatus.isNoSynced) {
        final report = await _remote.createPhoto(
            photo: photo, general: general!, feature: feature);
        if (report != null) {
          photo = photo.copyWith(
              id: report.id, image: report.image, status: SyncStatus.synced);
        }
        _local.cachePhotoToLocal(photo);
      }
    }

    await Future.forEach(
        _photos.where((photo) => photo.status == SyncStatus.isDeleted),
        (photo) async {
      if (photo.id != null &&
          _localPhoto.canDeleteLocalPhoto(id: photo.isarId)) {
        await _remotePhoto.deletePhoto(
            id: photo.id!, general: general!, feature: feature);
      }
      _localPhoto.deleteLocalPhoto(id: photo.isarId);
    });

    await Future.wait(photos
        .where((element) => element.status == SyncStatus.isNoSynced)
        .slices(3)
        .toList()
        .mapIndexed((i, uploadImageTasks) => Future.delayed(
            i.seconds,
            () => Future.wait(
                uploadImageTasks.map((e) async => await postPhoto(e))))));
  }
}
