import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/repository/repository.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';

import 'package:fms/features/urgency/domain/entities/urgency_entity.dart';

import '../../../../core/usecase/either.dart';
import '../../domain/repositories/urgency_team_repository.dart';
import '../datasources/urgency_team_remote_datasource.dart';

class UrgencyTeamRepositoryImpl extends Repository
    with GeneralDataMixin
    implements UrgencyTeamRepository {
  final UrgencyTeamRemoteDataSourceImpl _remote;

  UrgencyTeamRepositoryImpl(this._remote);
  @override
  Future<Result<List<UrgencyEntity>>> getReport(
      {required int featureId}) async {
    return todo(() async {
      final urgencies = await _remote.getReport(
          attendanceId: general!.attendance!.id!, featureId: featureId);
      return Right(urgencies);
    }, useInternet: true);
  }
}
