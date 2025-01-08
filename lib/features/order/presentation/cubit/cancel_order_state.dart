part of 'cancel_order_cubit.dart';

sealed class CancelOrderState extends Equatable {
  const CancelOrderState();

  @override
  List<Object> get props => [];
}

final class CancelOrderInitial extends CancelOrderState {}

final class CancelOrderLoading extends CancelOrderState {}

final class CancelOrderSuccess extends CancelOrderState {}

final class CancelOrderFailure extends CancelOrderState {
  final Failure failure;

  CancelOrderFailure(this.failure);
}
