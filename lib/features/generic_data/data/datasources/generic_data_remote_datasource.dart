import 'package:fms/core/data_source/remote_datasource.dart';
import 'package:fms/core/utilities/parser.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';

abstract class GenericDataRemoteDatasource {
  Future<NumericSheetEntity?> createGenericData(
      {required NumericSheetEntity model});
  Future<NumericSheetEntity?> getGenericData(
      {required int featureId, required int attendanceId});
}

class GenericDataRemoteDatasourceImpl extends RemoteDatasource
    implements GenericDataRemoteDatasource {
  @override
  Future<NumericSheetEntity?> createGenericData({
    required NumericSheetEntity model,
  }) async {
    final data = model.toMap();

    final _resp = await dio.post(
        path:
            '/app/attendances/${model.attendanceId}/features/${model.featureId}/numeric-sheets',
        data: data);

    return parseJson<NumericSheetEntity>(
        (fromJson: NumericSheetEntity.fromMap, json: _resp));
  }

  @override
  Future<NumericSheetEntity?> getGenericData(
      {required int featureId, required int attendanceId}) async {
    final _resp = await dio.get(
      path:
          '/app/attendances/${attendanceId}/features/${featureId}/numeric-sheets',
    );
    return parseJson<NumericSheetEntity>(
        (fromJson: NumericSheetEntity.fromMap, json: _resp));
  }
}
