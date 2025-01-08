import 'package:vnm/core/data_source/remote_datasource.dart';
import 'package:vnm/core/utilities/parser.dart';
import 'package:vnm/features/oos/data/models/oos_model.dart';

abstract class OOSRemoteDatatsource {
  Future<OOSModel?> createOOS({required OOSModel model});
  Future<OOSModel?> getCurrentOOS(
      {required int featureId, required int attendanceId});
}

class OosRemoteDatatsourceImpl extends RemoteDatasource
    implements OOSRemoteDatatsource {
  @override
  Future<OOSModel?> createOOS({required OOSModel model}) async {
    final data = model.toMap();

    final _resp = await dio.post(
        path:
            '/app/attendances/${model.attendanceId}/features/${model.featureId}/oos-statuses',
        data: data);

    return parseJson<OOSModel>((fromJson: OOSModel.fromMap, json: _resp));
  }

  @override
  Future<OOSModel?> getCurrentOOS(
      {required int featureId, required int attendanceId}) async {
    final _resp = await dio.get(
      path:
          '/app/attendances/${attendanceId}/features/${featureId}/oos-statuses',
    );

    return parseJson<OOSModel>((fromJson: OOSModel.fromMap, json: _resp));
  }
}
