part of 'oos_cubit.dart';

sealed class OosState {
  const OosState();
}

final class OosInitial extends OosState {}

final class OosLoading extends OosState {}

final class OosFailure extends OosState {
  final Failure failure;

  const OosFailure(this.failure);
}

final class OosSuccess extends OosState {
  final OOSEntity entity;

  const OosSuccess(this.entity);
}
