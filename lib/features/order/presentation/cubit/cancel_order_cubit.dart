import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/domain/usecases/cancel_order_usecase.dart';

part 'cancel_order_state.dart';

class CancelOrderCubit extends Cubit<CancelOrderState> {
  final CancelOrderUsecase _cancelOrderUsecase;
  CancelOrderCubit(this._cancelOrderUsecase) : super(CancelOrderInitial());

  Future<void> cancelOrder(
      {required FeatureEntity feature, required OrderEntity order}) async {
    emit(CancelOrderLoading());
    await _cancelOrderUsecase(CancelOrderParams(order: order, feature: feature))
      ..fold(
        (failure) => emit(CancelOrderFailure(failure)),
        (data) => emit(CancelOrderSuccess()),
      );
  }
}
