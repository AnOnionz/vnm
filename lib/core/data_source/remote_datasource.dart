import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/client/dio_client.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';

abstract class RemoteDatasource {
  late final DioClient dio;

  RemoteDatasource() {
    dio = Modular.get<DioClient>();
  }
}

class DefaultParams {
  final GeneralEntity general;
  final FeatureEntity feature;

  DefaultParams(this.general, this.feature);
}
