import 'package:vnm/core/mixins/extension/func_ext.dart';

import '../../../../core/constant/type_def.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../general/domain/entities/config_entity.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../entities/order_entity.dart';

class DeleteOrderUsecase extends UseCase<void, DeleteOrderParams> {
  final OrderRepositoryImpl repository;

  DeleteOrderUsecase(this.repository);
  @override
  Future<Result<void>> call(DeleteOrderParams params) async {
    return repository
        .deteleOrder(order: params.order, feature: params.feature)
        .withLoading();
  }
}

class DeleteOrderParams extends Params {
  final OrderEntity order;
  final FeatureEntity feature;

  DeleteOrderParams({required this.order, required this.feature});
}
