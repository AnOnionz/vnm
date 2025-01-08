import 'package:vnm/features/order/domain/entities/customer_identity.dart';

import '../../../../core/constant/type_def.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/repositories/order_repository_impl.dart';
import 'identify_customer_usecase.dart';

class IdentifyCustomerWithLimitsUsecase
    extends UseCase<CustomerIdentity, IdentifyCustomerParams> {
  final OrderRepositoryImpl repository;

  IdentifyCustomerWithLimitsUsecase(this.repository);
  @override
  Future<Result<CustomerIdentity>> call(IdentifyCustomerParams params) {
    return repository.identifyCustomerWithLimits(
        customerIdentities: params.customerIdentities,
        attendanceId: params.attendanceId,
        excludeOrderId: params.excludeOrderId,
        featureId: params.featureId);
  }
}
