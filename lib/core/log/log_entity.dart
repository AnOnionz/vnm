import 'package:isar/isar.dart';

part 'log_entity.g.dart';

@collection
class LogEntity {
  Id? id;
  final String createAt;
  final String? status;
  final String requestURl;
  final String requestData;
  final String requestHeader;
  final String responseData;

  LogEntity(
      {required this.createAt,
      required this.status,
      required this.requestURl,
      required this.requestData,
      required this.requestHeader,
      required this.responseData});

  @override
  String toString() {
    return 'LogEntity(id: $id, createAt: $createAt, statusCode: $status, requestURl: $requestURl, requestData: $requestData, requestHeader: $requestHeader, responseData: $responseData)';
  }
}
