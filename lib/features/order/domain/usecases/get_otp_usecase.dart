import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/domain/entities/verification_code_entity.dart';

import '../../../../core/constant/type_def.dart';

class GetOtpUsecase
    extends UseCase<VerificationCodeEntity?, VerificationParams> {
  final OrderRepositoryImpl repository;

  GetOtpUsecase(this.repository);
  @override
  Future<Result<VerificationCodeEntity?>> call(VerificationParams params) {
    return repository.getOTP(
        customerIdentities: params.customerIdentities,
        attendanceId: params.attendanceId,
        requestId: params.requestId,
        featureId: params.featureId);
  }
}

class VerificationParams {
  final List<CustomerInfo> customerIdentities;
  final String? requestId;
  final String? code;
  final int attendanceId;
  final int featureId;

  VerificationParams(
      {required this.customerIdentities,
      this.requestId,
      this.code,
      required this.attendanceId,
      required this.featureId});
}
