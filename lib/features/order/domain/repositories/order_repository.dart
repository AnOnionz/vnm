import 'package:fms/features/order/domain/entities/customer_identity.dart';
import 'package:fms/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:fms/features/order/domain/entities/customer_verification_code_entity.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/domain/entities/verification_code_entity.dart';

import '../../../../core/constant/type_def.dart';
import '../../../general/domain/entities/config_entity.dart';

abstract class OrderRepository {
  Future<Result<List<CustomerInfo>>> identifyCustomer(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId});
  Future<Result<CustomerIdentity>> identifyCustomerWithLimits(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      int? excludeOrderId,
      required int featureId});
  Future<Result<VerificationCodeEntity?>> getOTP(
      {required List<CustomerInfo> customerIdentities,
      String? requestId,
      required int attendanceId,
      required int featureId});
  Future<Result<CustomerVerificationCodeEntity?>> sendOTP(
      {required List<CustomerInfo> customerIdentities,
      required String code,
      required int attendanceId,
      required int featureId});
  Future<Result<CustomerInfoWithLuckyDrawEntity?>> getCustomerInfoWithLuckyDraw(
      {required int attendanceId, required int orderId});
  Future<Result<OrderEntity>> createOrder(
      {required OrderEntity order, required FeatureEntity feature});
  Future<Result<void>> deteleOrder(
      {required OrderEntity order, required FeatureEntity feature});
  Future<Result<void>> cancelOrder(
      {required OrderEntity order, required FeatureEntity feature});
  Future<Result<OrderEntity?>> fetchOrder(
      {required int orderId, required FeatureEntity feature});
  Future<Result<OrderEntity>> updateOrder(
      {required OrderEntity order, required FeatureEntity feature});

  Future<Result<List<OrderEntity>>> allOrders({required int featureId});

  Future<Result<FeatureEntity?>> getOrdersNotCompleted(
      {required FeatureEntity feature});
  Future<Result<Map<int, List<OrderEntity>>>> noSyncedData();
  Future<void> synchronized(FeatureEntity feature);
}
