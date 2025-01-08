import 'package:vnm/core/utilities/parser.dart';
import 'package:vnm/features/order/domain/entities/customer_identity.dart';
import 'package:vnm/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:vnm/features/order/domain/entities/customer_verification_code_entity.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../../images/data/datasource/images_remote_datasource.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/verification_code_entity.dart';

abstract class IOrderRemoteDataSource {
  Future<List<CustomerInfo>> getCustomerInfo(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId});
  Future<CustomerIdentity> getCustomerLimitInfo(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId});
  Future<OrderEntity?> createOrder(OrderEntity order);
  Future<OrderEntity?> fetchOrder(
      {required int orderId,
      required int attendanceId,
      required int featureId});
  Future<OrderEntity?> updateOrder(OrderEntity order);
  Future<OrderEntity?> deleteOrder(
      {required OrderEntity order,
      required int attendanceId,
      required int featureId});
  Future<PhotoEntity?> createPhoto(
      {required PhotoEntity photo,
      required int featureId,
      required int attendanceId,
      required int orderId});
  Future<List<OrderEntity>> fetchOrders(
      {required int attendanceId, required int featureId});
  Future<List<PhotoEntity>> fetchOrderPhotos(
      {required int attendanceId,
      required int featureId,
      required int orderId});
  Future<VerificationCodeEntity?> getOTP(
      {String? requestId,
      required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId});
  Future<CustomerVerificationCodeEntity?> sendOTP(
      {required List<CustomerInfo> customerIdentities,
      required String code,
      required int attendanceId,
      required int featureId});
  Future<CustomerInfoWithLuckyDrawEntity?> getCustomerInfoWithLuckyDraw({
    required int attendanceId,
    required int orderId,
  });
}

class OrderRemoteDataSource extends ImagesRemoteDataSource
    implements IOrderRemoteDataSource {
  @override
  Future<List<CustomerInfo>> getCustomerInfo(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId}) async {
    final data = {
      'fields': customerIdentities
          .map((customerIdentity) =>
              '${customerIdentity.featureCustomerId},${customerIdentity.value ?? ''}')
          .toList()
    };

    final _resp = await dio.get(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/customer',
        queryParameters: data);

    if (_resp == null || _resp == '') {
      return [];
    }
    return parseListJson((
      listJson: _resp['customerInfos'] as List<dynamic>,
      fromJson: CustomerInfo.fromMap
    ));
  }

  @override
  Future<CustomerIdentity> getCustomerLimitInfo(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      int? excludeOrderId,
      required int featureId}) async {
    final Map<String, dynamic> data = {
      'fields': customerIdentities
          .map((customerIdentity) =>
              '${customerIdentity.featureCustomerId},${customerIdentity.value ?? ''}')
          .toList()
    };
    if (excludeOrderId != null) {
      data['excludeOrderId'] = excludeOrderId;
    }

    final _resp = await dio.get(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/customer-profile',
        queryParameters: data);

    if (_resp == null || _resp == '') {
      return CustomerIdentity.empty();
    }
    return parseJson((json: _resp, fromJson: CustomerIdentity.fromMap)) ??
        CustomerIdentity.empty();
  }

  @override
  Future<OrderEntity?> createOrder(OrderEntity order) async {
    final data = order.toMap();
    final _resp = await dio.post(
        path:
            '/app/attendances/${order.attendanceId}/features/${order.featureId}/orders',
        data: data);

    return parseJson<OrderEntity>((json: _resp, fromJson: OrderEntity.fromMap));
  }

  @override
  Future<OrderEntity?> fetchOrder(
      {required int orderId,
      required int attendanceId,
      required int featureId}) async {
    final _resp = await dio.get(
      path:
          '/app/attendances/${attendanceId}/features/${featureId}/orders/${orderId}',
    );

    return parseJson<OrderEntity>((json: _resp, fromJson: OrderEntity.fromMap));
  }

  @override
  Future<List<OrderEntity>> fetchOrders(
      {required int attendanceId, required int featureId}) async {
    final _resp = await dio.get(
        path: '/app/attendances/${attendanceId}/features/${featureId}/orders');

    return parseListJson((listJson: _resp, fromJson: OrderEntity.fromMap));
  }

  @override
  Future<OrderEntity?> updateOrder(OrderEntity order) async {
    final data = order.toUpdateMap();
    final _resp = await dio.put(
        path:
            '/app/attendances/${order.attendanceId}/features/${order.featureId}/orders/${order.id}',
        data: data);
    return parseJson((json: _resp, fromJson: OrderEntity.fromMap));
  }

  @override
  Future<List<PhotoEntity>> fetchOrderPhotos(
      {required int attendanceId,
      required int featureId,
      required int orderId}) async {
    final _resp = await dio.get(
      path:
          '/app/attendances/${attendanceId}/features/${featureId}/orders/${orderId}/photos',
    );

    return parseListJson((listJson: _resp, fromJson: PhotoEntity.fromMap));
  }

  @override
  Future<PhotoEntity?> createPhoto(
      {required PhotoEntity photo,
      required int featureId,
      required int attendanceId,
      required int orderId}) async {
    Map<String, dynamic> formData;
    if (photo.image != null) {
      formData = {
        'dataUuid': photo.dataUuid,
        'dataTimestamp': photo.dataTimestamp.toUtc().toIso8601String(),
        'featurePhotoId': photo.featurePhotoId,
        'imageId': photo.image!.id,
      };
    } else {
      final imageUploadModel = await uploadImageToServer(XFile(photo.path!));
      if (imageUploadModel != null) {
        formData = {
          'dataUuid': photo.dataUuid,
          'dataTimestamp': photo.dataTimestamp.toUtc().toIso8601String(),
          'featurePhotoId': photo.featurePhotoId,
          'imageId': imageUploadModel.id,
        };
      } else {
        return null;
      }
    }

    final _resp = await dio.post(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/${orderId}/photos',
        data: formData);

    return parseJson<PhotoEntity>((json: _resp, fromJson: PhotoEntity.fromMap));
  }

  @override
  Future<OrderEntity?> deleteOrder(
      {required OrderEntity order,
      required int attendanceId,
      required int featureId}) async {
    final _resp = await dio.delete(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/${order.id}');
    return parseJson<OrderEntity>((json: _resp, fromJson: OrderEntity.fromMap));
  }

  @override
  Future<VerificationCodeEntity?> getOTP(
      {String? requestId,
      required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId}) async {
    final Map<String, dynamic> data = {
      'fields': customerIdentities
          .map((customerIdentity) =>
              '${customerIdentity.featureCustomerId},${customerIdentity.value ?? ''}')
          .toList(),
    };
    if (requestId != null) {
      data['requestId'] = requestId;
    }

    final _resp = await dio.get(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/customer-verification',
        queryParameters: data);

    return parseJson<VerificationCodeEntity>(
        (json: _resp, fromJson: VerificationCodeEntity.fromMap));
  }

  @override
  Future<CustomerVerificationCodeEntity?> sendOTP(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required String code,
      required int featureId}) async {
    final Map<String, dynamic> data = {
      'fields': customerIdentities
          .map((customerIdentity) =>
              '${customerIdentity.featureCustomerId},${customerIdentity.value ?? ''}')
          .toList(),
    };
    final _resp = await dio.post(
        path:
            '/app/attendances/${attendanceId}/features/${featureId}/orders/customer-verification',
        queryParameters: data,
        data: {'code': code});

    return parseJson<CustomerVerificationCodeEntity>(
        (json: _resp, fromJson: CustomerVerificationCodeEntity.fromMap));
  }

  @override
  Future<CustomerInfoWithLuckyDrawEntity?> getCustomerInfoWithLuckyDraw(
      {required int attendanceId, required int orderId}) async {
    final _resp = await dio.get(
        path: '/app/attendances/${attendanceId}/orders/${orderId}/lucky-draws');

    return parseJson<CustomerInfoWithLuckyDrawEntity>(
        (json: _resp, fromJson: CustomerInfoWithLuckyDrawEntity.fromMap));
  }
}
