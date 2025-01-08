import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';

import '../../../general/domain/entities/config_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/delete_order_usecase.dart';

part 'delete_order_state.dart';

class DeleteOrderCubit extends Cubit<DeleteOrderState> {
  final DeleteOrderUsecase deleteOrderUsecase;
  DeleteOrderCubit(this.deleteOrderUsecase) : super(DeleteOrderInitial());

  Future<void> deleteOrder(
      {required OrderEntity order, required FeatureEntity feature}) async {
    emit(DeleteOrderLoading());
    final result = await deleteOrderUsecase(
        DeleteOrderParams(order: order, feature: feature));
    result.fold((failure) => emit(DeleteOrderFailure(failure: failure)),
        (r) => emit(DeleteOrderSuccess()));
  }
}
