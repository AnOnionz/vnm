import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/customer_verification_code_entity.dart';

import 'get_otp_usecase.dart';

class SendOtpUsecase
    extends UseCase<CustomerVerificationCodeEntity?, VerificationParams> {
  final OrderRepositoryImpl repository;

  SendOtpUsecase(this.repository);
  @override
  Future<Result<CustomerVerificationCodeEntity?>> call(
      VerificationParams params) {
    return repository.sendOTP(
        customerIdentities: params.customerIdentities,
        code: params.code!,
        attendanceId: params.attendanceId,
        featureId: params.featureId);
  }
}
