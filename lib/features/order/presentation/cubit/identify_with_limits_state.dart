part of 'identify_with_limits_cubit.dart';

sealed class IdentifyWithLimitsState extends Equatable {
  const IdentifyWithLimitsState();

  @override
  List<Object> get props => [];
}

final class IdentifyWithLimitsInitial extends IdentifyWithLimitsState {}

final class IdentifyWithLimitsLoading extends IdentifyWithLimitsState {}

final class IdentifyWithLimitsSuccess extends IdentifyWithLimitsState {
  final CustomerIdentity customer;

  IdentifyWithLimitsSuccess(this.customer);
}

final class IdentifyWithLimitsFailure extends IdentifyWithLimitsState {
  final Failure failure;

  IdentifyWithLimitsFailure(this.failure);
}
