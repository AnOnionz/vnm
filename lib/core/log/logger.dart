import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:path_provider/path_provider.dart';

import '../database/database.dart';
import '../services/network_time/network_time_service.dart';
import 'log_entity.dart';

class MyLoggger {
  final db = Database.instance;
  final timeService = Modular.get<NetworkTimeService>();

  Future<void> log(dynamic data) async {
    final time = await timeService.ntpDateTime();
    final Response<dynamic>? response =
        data is DioException ? data.response : (data as Response);
    final RequestOptions requestOptions = data is DioException
        ? data.requestOptions
        : (data as Response).requestOptions;

    final String status = data is DioException
        ? data.type.name
        : (data as Response).statusCode.toString();

    final newLog = LogEntity(
        status: status,
        createAt: time.formatBy(khmsdMy),
        requestURl: requestOptions.baseUrl + requestOptions.path,
        requestData: requestToString(requestOptions.data),
        requestHeader: requestOptions.headers.toString(),
        responseData: response.toString());

    db.addObject<LogEntity>(newLog);
  }

  Future<File?> exportFileJson() async {
    final logs = db.exportJson<LogEntity>();
    if (logs.isEmpty) return null;

    final lastLog =
        ('to ' + (logs.last['createAt'] as String)).replaceAll(' ', '_');
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${lastLog}.json';
    var logfile = File(path);
    if (!logfile.existsSync()) {
      logfile = await File(path).create(recursive: true);
    }

    final jsonData = jsonEncode(
      logs,
    );

    await logfile.writeAsString(jsonData);

    return logfile;
  }

  String requestToString(dynamic data) {
    if (data is FormData) {
      return json.encode(Map.fromEntries(data.fields
        ..addAll(data.files.map((e) => MapEntry(e.key, e.value.toString())))));
    }
    return data.toString();
  }
}
