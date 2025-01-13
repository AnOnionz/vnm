import 'package:fms/core/mixins/extension/func_ext.dart';

import '../../../../core/constant/type_def.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../general/domain/entities/config_entity.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../entities/order_entity.dart';

class GetOrderUsecase extends UseCase<OrderEntity?, GetOrderParams> {
  final OrderRepositoryImpl repository;

  GetOrderUsecase(this.repository);
  @override
  Future<Result<OrderEntity?>> call(GetOrderParams params) async {
    return repository
        .fetchOrder(orderId: params.orderId, feature: params.feature)
        .withLoading();
  }
}

class GetOrderParams extends Params {
  final int orderId;
  final FeatureEntity feature;

  GetOrderParams({required this.orderId, required this.feature});
}
