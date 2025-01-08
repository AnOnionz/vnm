import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/repository/repository.dart';
import 'package:vnm/core/usecase/either.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';

import '../../domain/repositories/urgency_repository.dart';
import '../datasources/urgency_remote_datasource.dart';

class UrgencyRepositoryImpl extends Repository
    with GeneralDataMixin
    implements UrgencyRepository {
  final UrgencyRemoteDataSourceImpl _remote;

  UrgencyRepositoryImpl({required UrgencyRemoteDataSourceImpl remote})
      : _remote = remote;

  @override
  Future<Result<UrgencyEntity?>> beginUrgency(
      {required int featureId,
      required int featureUrgencyId,
      String? note}) async {
    return todo(() async {
      final urgency = await _remote.beginUrgency(
          attendanceId: general!.attendance!.id!,
          featureId: featureId,
          featureUrgencyId: featureUrgencyId,
          note: note);

      return Right(urgency);
    });
  }

  @override
  Future<Result<UrgencyEntity?>> currentUrgency(
      {required int featureId}) async {
    return todo(() async {
      if (general!.attendance == null || general!.attendance!.dataOut != null)
        return Right(null);
      final urgency = await _remote.currentUrgency(
          attendanceId: general!.attendance!.id!, featureId: featureId);

      return Right(urgency);
    }, useInternet: true);
  }

  @override
  Future<Result<UrgencyEntity?>> endUrgency({required int featureId}) async {
    return todo(() async {
      final urgency = await _remote.endUrgency(
          attendanceId: general!.attendance!.id!, featureId: featureId);

      return Right(urgency);
    });
  }
}
