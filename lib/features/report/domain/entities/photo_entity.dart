// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/features/attendance/domain/entities/attendance_entity.dart';
import 'package:isar/isar.dart';

import '../../../../core/cache_image_network/cache_image_manager.dart';
import '../../../../core/utilities/parser.dart';
import '../../../general/domain/entities/data_entity.dart';

part 'photo_entity.g.dart';

@collection
class PhotoEntity extends BaseEntity {
  Id get isarId => fastHash(dataUuid);
  int? id;
  String dataUuid;
  int? attendanceId;
  int? featureId;
  String? path;
  DateTime dataTimestamp;
  int featurePhotoId;
  ImageCloud? image;
  @Enumerated(EnumType.name)
  SyncStatus status;

  PhotoEntity(
      {this.id,
      required this.dataUuid,
      required this.dataTimestamp,
      required this.featurePhotoId,
      this.image,
      this.path,
      this.status = SyncStatus.isNoSynced,
      this.attendanceId,
      this.featureId});
  @ignore
  Future<String> get imageUrl => _takePhotoPath();

  factory PhotoEntity.fromMap(Map<String, dynamic> map,
      {bool isSynced = false}) {
    return PhotoEntity(
        id: map['id'] as int,
        dataUuid: map['dataUuid'] as String,
        dataTimestamp: DateTime.parse(map['dataTimestamp'] as String).toLocal(),
        featurePhotoId: map['featurePhotoId'] != null
            ? map['featurePhotoId'] as int
            : map['featureMultimediaId'] as int,
        image: ImageCloud.fromMap(map['image'] as Map<String, dynamic>),
        status: isSynced ? SyncStatus.synced : SyncStatus.isNoSynced);
  }

  factory PhotoEntity.fromJson(String source) =>
      PhotoEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  PhotoEntity copyWith({
    int? id,
    int? attendanceId,
    int? featureId,
    String? dataUuid,
    String? path,
    DateTime? dataTimestamp,
    int? featurePhotoId,
    ImageCloud? image,
    SyncStatus? status,
  }) {
    return PhotoEntity(
      id: id ?? this.id,
      attendanceId: attendanceId ?? this.attendanceId,
      dataUuid: dataUuid ?? this.dataUuid,
      path: path ?? this.path,
      dataTimestamp: dataTimestamp ?? this.dataTimestamp,
      featureId: featureId ?? this.featureId,
      featurePhotoId: featurePhotoId ?? this.featurePhotoId,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  Future<String> _takePhotoPath() async {
    if (path.isNotEmptyAndNotNull && File(path!).existsSync()) return path!;
    if (image != null) {
      final imageFile = await CacheImageMagager.getFile(
          image!.getImage(image: ImageType.original));
      return imageFile.path;
    }
    return '';
  }

  @override
  String toString() {
    return 'PhotoEntity(id: $id,  status: $status,dataUuid: $dataUuid, attendanceId: $attendanceId, featureId: $featureId,  path: $path, dataTimestamp: $dataTimestamp, featurePhotoId: $featurePhotoId, image: $image)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoEntity &&
          runtimeType == other.runtimeType &&
          dataUuid == other.dataUuid &&
          status == other.status;

  @override
  int get hashCode => dataUuid.hashCode;
}
