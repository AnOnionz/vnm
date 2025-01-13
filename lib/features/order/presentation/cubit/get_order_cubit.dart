import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';

import '../../../general/domain/entities/config_entity.dart';
import '../../domain/usecases/get_order.usecase.dart';

part 'get_order_state.dart';

class GetOrderCubit extends Cubit<GetOrderState> {
  final GetOrderUsecase getOrder;
  GetOrderCubit(this.getOrder) : super(GetOrderInitial());

  Future<void> getOrderById(
      {required int orderId, required FeatureEntity feature}) async {
    emit(GetOrderLoading());
    final execute =
        await getOrder(GetOrderParams(orderId: orderId, feature: feature));
    execute.fold((failure) => emit(GetOrderFailure(failure)),
        (order) => emit(GetOrderSuccess(order: order)));
  }
}
