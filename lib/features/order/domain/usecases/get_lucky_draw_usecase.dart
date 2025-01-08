import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/order/data/repositories/order_repository_impl.dart';
import 'package:vnm/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';

class GetLuckyDrawUsecase
    extends UseCase<CustomerInfoWithLuckyDrawEntity?, LuckyDrawParams> {
  final OrderRepositoryImpl repository;

  GetLuckyDrawUsecase(this.repository);
  @override
  Future<Result<CustomerInfoWithLuckyDrawEntity?>> call(
      LuckyDrawParams params) {
    return repository.getCustomerInfoWithLuckyDraw(
        attendanceId: params.attendanceId, orderId: params.orderId);
  }
}

class LuckyDrawParams {
  final int attendanceId;
  final int orderId;

  LuckyDrawParams({required this.attendanceId, required this.orderId});
}
