import 'package:fms/features/urgency/data/models/urgency_model.dart';

import '../../../../core/data_source/remote_datasource.dart';
import '../../../../core/utilities/parser.dart';

abstract class UrgencyRemoteDataSource {
  Future<UrgencyModel?> beginUrgency(
      {required int attendanceId,
      required int featureId,
      required int featureUrgencyId,
      String? note});
  Future<UrgencyModel?> endUrgency(
      {required int attendanceId, required int featureId});
  Future<UrgencyModel?> currentUrgency(
      {required int attendanceId, required int featureId});
}

class UrgencyRemoteDataSourceImpl extends RemoteDatasource
    implements UrgencyRemoteDataSource {
  @override
  Future<UrgencyModel?> beginUrgency(
      {required int attendanceId,
      required int featureId,
      required int featureUrgencyId,
      String? note}) async {
    final data = Map<String, dynamic>();
    data['featureUrgencyId'] = featureUrgencyId;
    if (note != null) {
      data['note'] = note;
    }
    final _resp = await dio.post(
        path: '/app/attendances/${attendanceId}/features/${featureId}/urgency',
        data: data);

    return parseJson((json: _resp, fromJson: UrgencyModel.fromMap));
  }

  @override
  Future<UrgencyModel?> currentUrgency(
      {required int attendanceId, required int featureId}) async {
    final _resp = await dio.get(
        path: '/app/attendances/${attendanceId}/features/${featureId}/urgency');

    return parseJson((json: _resp, fromJson: UrgencyModel.fromMap));
  }

  @override
  Future<UrgencyModel?> endUrgency(
      {required int attendanceId, required int featureId}) async {
    final _resp = await dio.put(
        path: '/app/attendances/${attendanceId}/features/${featureId}/urgency');

    return parseJson((json: _resp, fromJson: UrgencyModel.fromMap));
  }
}
