import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';

class IdentifyCustomerUsecase
    extends UseCase<List<CustomerInfo>, IdentifyCustomerParams> {
  final OrderRepositoryImpl repository;

  IdentifyCustomerUsecase(this.repository);
  @override
  Future<Result<List<CustomerInfo>>> call(IdentifyCustomerParams params) {
    return repository.identifyCustomer(
        customerIdentities: params.customerIdentities,
        attendanceId: params.attendanceId,
        featureId: params.featureId);
  }
}

class IdentifyCustomerParams {
  final List<CustomerInfo> customerIdentities;
  final int attendanceId;
  final int? excludeOrderId;
  final int featureId;

  IdentifyCustomerParams(
      {required this.customerIdentities,
      required this.attendanceId,
      this.excludeOrderId,
      required this.featureId});
}
