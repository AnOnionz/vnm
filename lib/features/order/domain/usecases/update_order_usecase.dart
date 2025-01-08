import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';

class UpdateOrderUsecase extends UseCase<OrderEntity, UpdateOrderParams> {
  final OrderRepositoryImpl repository;

  UpdateOrderUsecase(this.repository);
  @override
  Future<Result<OrderEntity>> call(UpdateOrderParams params) async {
    return repository
        .updateOrder(order: params.order, feature: params.feature)
        .withLoading();
  }
}

class UpdateOrderParams {
  final OrderEntity order;
  final FeatureEntity feature;

  UpdateOrderParams({required this.order, required this.feature});
}
