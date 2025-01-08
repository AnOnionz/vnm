// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class CreateOrder extends OrderEvent {
  final OrderEntity order;
  final FeatureEntity feature;

  CreateOrder({required this.order, required this.feature});
}

class UpdateOrder extends OrderEvent {
  final OrderEntity order;
  final FeatureEntity feature;

  UpdateOrder({required this.order, required this.feature});

  @override
  String toString() => 'UpdateOrder(feature: $feature, order: $order, )';
}
