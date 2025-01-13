import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/mixins/extension/func_ext.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/order/data/repositories/order_repository_impl.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';

class CancelOrderUsecase extends UseCase<void, CancelOrderParams> {
  final OrderRepositoryImpl repository;

  CancelOrderUsecase(this.repository);
  @override
  Future<Result<void>> call(CancelOrderParams params) async {
    return repository
        .cancelOrder(order: params.order, feature: params.feature)
        .withLoading();
  }
}

class CancelOrderParams {
  final OrderEntity order;
  final FeatureEntity feature;

  CancelOrderParams({required this.order, required this.feature});
}
