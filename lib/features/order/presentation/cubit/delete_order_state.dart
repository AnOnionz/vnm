part of 'delete_order_cubit.dart';

sealed class DeleteOrderState extends Equatable {
  const DeleteOrderState();

  @override
  List<Object> get props => [];
}

final class DeleteOrderInitial extends DeleteOrderState {}

final class DeleteOrderLoading extends DeleteOrderState {}

final class DeleteOrderSuccess extends DeleteOrderState {}

final class DeleteOrderFailure extends DeleteOrderState {
  final Failure failure;

  DeleteOrderFailure({required this.failure});
}
