import 'package:collection/collection.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/data_source/local_data_source.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/repository/repository.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/order/data/datasources/order_local_datasource.dart';
import 'package:fms/features/order/data/datasources/order_remote_datasource.dart';
import 'package:fms/features/order/domain/entities/customer_identity.dart';
import 'package:fms/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:fms/features/order/domain/entities/customer_verification_code_entity.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/domain/entities/verification_code_entity.dart';
import 'package:fms/features/order/domain/repositories/order_repository.dart';
import '../../../../core/usecase/either.dart';
import '../../../general/presentation/page/mixin_general.dart';
import '../../../images/data/datasource/delete_image_local_remote_datasource.dart';
import '../../../images/data/datasource/delete_image_remote_datasource.dart';
import '../../../report/domain/entities/photo_entity.dart';

class OrderRepositoryImpl extends Repository
    with GeneralDataMixin, LocalDatasource
    implements OrderRepository {
  final OrderLocalDataSource _local;
  final OrderRemoteDataSource _remote;
  final DeletePhotoRemoteDataSource _remotePhoto;
  final DeletePhotoLocalDataSource _localPhoto;

  OrderRepositoryImpl(
      this._local, this._remote, this._remotePhoto, this._localPhoto);
  @override
  Future<Result<List<CustomerInfo>>> identifyCustomer(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required int featureId}) {
    return todo(() async {
      final customerInfos = await _remote.getCustomerInfo(
          customerIdentities: customerIdentities,
          attendanceId: attendanceId,
          featureId: featureId);

      return Right(customerInfos);
    }, useInternet: true);
  }

  @override
  Future<Result<CustomerIdentity>> identifyCustomerWithLimits(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      int? excludeOrderId,
      required int featureId}) {
    return todo(() async {
      final customerInfos = await _remote.getCustomerLimitInfo(
          customerIdentities: customerIdentities,
          attendanceId: attendanceId,
          excludeOrderId: excludeOrderId,
          featureId: featureId);

      return Right(customerInfos);
    }, useInternet: true);
  }

  @override
  Future<Result<VerificationCodeEntity?>> getOTP(
      {required List<CustomerInfo> customerIdentities,
      String? requestId,
      required int attendanceId,
      required int featureId}) async {
    return todo(() async {
      final verify = await _remote.getOTP(
          customerIdentities: customerIdentities,
          attendanceId: attendanceId,
          requestId: requestId,
          featureId: featureId);

      return Right(verify);
    }, useInternet: true);
  }

  @override
  Future<Result<CustomerVerificationCodeEntity?>> sendOTP(
      {required List<CustomerInfo> customerIdentities,
      required int attendanceId,
      required String code,
      required int featureId}) async {
    return todo(() async {
      final success = await _remote.sendOTP(
          customerIdentities: customerIdentities,
          code: code,
          attendanceId: attendanceId,
          featureId: featureId);

      return Right(success);
    }, useInternet: true);
  }

  @override
  Future<Result<CustomerInfoWithLuckyDrawEntity?>> getCustomerInfoWithLuckyDraw(
      {required int attendanceId, required int orderId}) async {
    return todo(() async {
      final data = await _remote.getCustomerInfoWithLuckyDraw(
          attendanceId: attendanceId, orderId: orderId);

      return Right(data);
    }, useInternet: true);
  }

  @override
  Future<Result<List<OrderEntity>>> allOrders({required int featureId}) async {
    return todo(() async {
      final Set<OrderEntity> orders = {};
      final offlineOrders = await _local.getOrdersByFeature(featureId);
      await allOnlineOrders(featureId: featureId)
        ..fold((failure) {
          orders.addAll(offlineOrders);
        }, (onlineOrders) {
          orders.addAll([
            ...offlineOrders,
            ...onlineOrders,
          ].toSet());
        });

      return Right(orders.sorted((a, b) =>
          b.dataTimestamp.millisecondsSinceEpoch -
          a.dataTimestamp.millisecondsSinceEpoch));
    });
  }

  Future<Result<List<OrderEntity>>> allOnlineOrders(
      {required int featureId}) async {
    return todo(() async {
      final onlineOrders = await _remote.fetchOrders(
          featureId: featureId, attendanceId: general!.attendance!.id!);

      return Right(onlineOrders);
    }, useInternet: true);
  }

  @override
  Future<Result<OrderEntity>> createOrder(
      {required OrderEntity order, required FeatureEntity feature}) {
    return todo(() async {
      if (feature.isImmediateSendRequired ?? false) {
        final newOrder = await _remote.createOrder(order);
        if (newOrder == null) return Left(DataNullFailure());
        order = order.copyWith(id: newOrder.id, status: SyncStatus.synced);
        _local.cacheOrderToLocal(order);
        await updatePhotos(order);
        _local.cacheOrderToLocal(order);
        return Right(order);
      }
      _remote.createOrder(order).then((newOrder) async {
        if (newOrder != null) {
          order = order.copyWith(id: newOrder.id);
          await updatePhotos(order);
          order = order.copyWith(status: SyncStatus.synced);
          _local.cacheOrderToLocal(order);
        } else {
          if (order.photos != null) {
            order.photos!.forEach((photo) {
              _local.cachePhotoToLocal(photo);
            });
            _local.cacheOrderToLocal(order);
            order.localPhotos.addAll(order.photos!);
            db.writeTxnSync(() => order.localPhotos.saveSync());
          } else {
            _local.cacheOrderToLocal(order);
          }
        }
      }).onError(
        (error, stackTrace) {
          if (order.photos != null) {
            order.photos!.forEach((photo) {
              _local.cachePhotoToLocal(photo);
            });
            _local.cacheOrderToLocal(order);
            order.localPhotos.addAll(order.photos!);
            db.writeTxnSync(() => order.localPhotos.saveSync());
          } else {
            _local.cacheOrderToLocal(order);
          }
        },
      );

      return Right(order);
    });
  }

  @override
  Future<Result<void>> deteleOrder(
      {required OrderEntity order, required FeatureEntity feature}) async {
    if (order.status == SyncStatus.synced) {
      return todo(() async {
        await _remote.deleteOrder(
            order: order,
            attendanceId: general!.attendance!.id!,
            featureId: feature.id!);
        _local.deleteOrderById(order.isarId);
        return Right(Never);
      }, useInternet: true);
    }
    if (order.status == SyncStatus.isNoSynced) {
      _local.deleteOrderById(order.isarId);
    }

    return Right(Never);
  }

  @override
  Future<Result<void>> cancelOrder(
      {required OrderEntity order, required FeatureEntity feature}) async {
    return todo(() async {
      final localOrder = await _local.getOrderByUuid(order.dataUuid);
      if (localOrder == null) return Right(Never);
      await _remote.deleteOrder(
          order: localOrder,
          attendanceId: general!.attendance!.id!,
          featureId: feature.id!);
      _local.deleteOrderById(localOrder.isarId);
      return Right(Never);
    }, useInternet: true);
  }

  @override
  Future<Result<OrderEntity?>> fetchOrder(
      {required int orderId, required FeatureEntity feature}) async {
    return todo(() async {
      final order = await _remote.fetchOrder(
          orderId: orderId,
          attendanceId: general!.attendance!.id!,
          featureId: feature.id!);
      if (order != null) {
        final localOrder = await _local.getOrderByUuid(order.dataUuid);
        if (localOrder != null) {
          //mix photo local and remote
          final photos = Set<PhotoEntity>.from(
              localOrder.localPhotos.toList()..addAll(order.photos ?? []));
          final newOrder = order.copyWith(photos: photos.toList());

          return Right(newOrder);
        }
      }

      return Right(order);
    });
  }

  @override
  Future<Result<OrderEntity>> updateOrder(
      {required OrderEntity order, required FeatureEntity feature}) async {
    return todo(() async {
      final newOrder = await _remote.updateOrder(order);
      order = order.copyWith(id: newOrder!.id, status: SyncStatus.synced);
      await updatePhotos(order);
      final existOrder = await _local.getOrderByUuid(order.dataUuid);
      if (existOrder != null) {
        _local.cacheOrderToLocal(existOrder.copyWith(
            attendanceId: order.attendanceId,
            featureId: order.featureId,
            customerInfos: order.customerInfos,
            exchanges: order.exchanges,
            purchases: order.purchases,
            samplings: order.samplings,
            prizes: order.prizes));
        existOrder.localPhotos.addAll(order.photos!);
        db.writeTxnSync(() => existOrder.localPhotos.saveSync());
      }

      return Right(order);
    }, useInternet: true);
  }

  @override
  Future<Result<FeatureEntity?>> getOrdersNotCompleted(
      {required FeatureEntity feature}) async {
    final orders = await _local.getOrders();
    if (orders.isEmpty) {
      return Right(feature);
    }
    return Right(null);
  }

  @override
  Future<Result<Map<int, List<OrderEntity>>>> noSyncedData() {
    return todo(() async {
      final localOrders = await _local.getOrders();
      final map = localOrders.groupListsBy((element) => element.featureId!);
      map.entries.forEach(
        (element) {
          element.value
              .removeWhere((element) => element.status == SyncStatus.synced);
        },
      );
      return Right(map);
    });
  }

  @override
  Future<void> synchronized(FeatureEntity feature) async {
    final ordersNoSynced = await _local.getOrdersNoSyncedByFeature(feature.id!);

    await Future.forEach(ordersNoSynced, (order) async {
      OrderEntity? newOrder;
      if (order.id == null) {
        newOrder = await _remote.createOrder(order);
        if (newOrder != null) {
          order = order.copyWith(id: newOrder.id);
          await updatePhotos(order);
          order = order.copyWith(status: SyncStatus.synced, id: newOrder.id!);
        }
      } else {
        await updatePhotos(order);
        order = order.copyWith(status: SyncStatus.synced);
      }

      _local.cacheOrderToLocal(order);
    });
  }

  Future<OrderEntity?> updatePhotos(OrderEntity order,
      {bool isOnline = false}) async {
    final _photos = (order.photos ?? order.localPhotos.toList())
      ..sortByCompare(
        (element) => element.status,
        (a, b) => b.index.compareTo(a.index),
      );

    Future<PhotoEntity?> postPhoto(PhotoEntity photo) async {
      if (photo.status == SyncStatus.isNoSynced) {
        final resp = await _remote.createPhoto(
            photo: photo,
            featureId: order.featureId!,
            attendanceId: order.attendanceId!,
            orderId: order.id!);
        if (resp != null) {
          photo = photo.copyWith(
              id: resp.id, image: resp.image, status: SyncStatus.synced);
          return photo;
        }
      }
      return null;
    }

    await Future.forEach(
        _photos.where((photo) => photo.status == SyncStatus.isDeleted),
        (photo) async {
      if (photo.image != null &&
          _localPhoto.canDeleteLocalPhoto(id: photo.isarId)) {
        await _remotePhoto.deleteOrderPhoto(
            featureId: order.featureId!,
            attendanceId: order.attendanceId!,
            id: photo.id!,
            orderId: order.id!);
      }
      _localPhoto.deleteLocalPhoto(id: photo.isarId);
    });

    await Future.wait(_photos
        .where((element) => element.status == SyncStatus.isNoSynced)
        .slices(3)
        .toList()
        .mapIndexed((i, uploadImageTasks) => Future.delayed(
            i.seconds,
            () => Future.wait(uploadImageTasks.map((e) async {
                  final photo = await postPhoto(e);
                  if (photo != null) {
                    order.localPhotos.add(photo);
                    _local.cachePhotoToLocal(photo);
                  }
                })))));

    if (isOnline == false) return null;
    return order;
  }
}
