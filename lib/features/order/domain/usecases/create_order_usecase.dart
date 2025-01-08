import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';

import '../../../general/domain/entities/config_entity.dart';

class CreateOrderUsecase extends UseCase<OrderEntity, CreateOrderParams> {
  final OrderRepositoryImpl repository;

  CreateOrderUsecase(this.repository);
  @override
  Future<Result<OrderEntity>> call(CreateOrderParams params) async {
    return repository
        .createOrder(order: params.order, feature: params.feature)
        .withLoading();
  }
}

class CreateOrderParams {
  final OrderEntity order;
  final FeatureEntity feature;

  CreateOrderParams({required this.order, required this.feature});
}
