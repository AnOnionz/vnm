import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/attendance/domain/entities/attendance_entity.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/attendance_repository_impl.dart';

class AttendanceUsecase extends UseCase<AttendanceEntity?, AttendanceParams> {
  final AttendanceRepositoryImpl repository;

  AttendanceUsecase(this.repository);

  @override
  Future<Result<AttendanceEntity?>> call(params) {
    return repository
        .postAttendance(
            file: params.file,
            position: params.position,
            time: params.time,
            feature: params.feature,
            isFaceRequired: params.isFaceRequired)
        .withLoading();
  }
}

class AttendanceParams {
  final XFile? file;
  final Position? position;
  final DateTime time;
  final FeatureEntity feature;
  bool isFaceRequired;

  AttendanceParams(
      {this.file,
      this.position,
      required this.time,
      required this.feature,
      this.isFaceRequired = false});
}
