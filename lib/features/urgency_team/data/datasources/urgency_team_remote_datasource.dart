import 'package:vnm/core/data_source/remote_datasource.dart';

import '../../../../core/utilities/parser.dart';
import '../../../urgency/data/models/urgency_model.dart';

abstract class UrgencyTeamRemoteDataSource {
  Future<List<UrgencyModel>> getReport(
      {required int attendanceId, required int featureId});
}

class UrgencyTeamRemoteDataSourceImpl extends RemoteDatasource
    implements UrgencyTeamRemoteDataSource {
  @override
  Future<List<UrgencyModel>> getReport(
      {required int attendanceId, required int featureId}) async {
    final _resp = await dio.get(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/team-reports/urgencies');

    return parseListJson((listJson: _resp, fromJson: UrgencyModel.fromMap));
  }
}
