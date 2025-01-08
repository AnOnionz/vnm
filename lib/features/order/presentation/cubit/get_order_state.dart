part of 'get_order_cubit.dart';

sealed class GetOrderState extends Equatable {
  const GetOrderState();

  @override
  List<Object> get props => [];
}

final class GetOrderInitial extends GetOrderState {}

final class GetOrderLoading extends GetOrderState {}

final class GetOrderSuccess extends GetOrderState {
  final OrderEntity? order;

  GetOrderSuccess({required this.order});
}

final class GetOrderFailure extends GetOrderState {
  final Failure failure;

  GetOrderFailure(this.failure);
}
