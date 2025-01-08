part of 'fetch_oos_cubit.dart';

sealed class FetchOosState {
  const FetchOosState();
}

final class FetchOosInitial extends FetchOosState {}

final class FetchOosLoading extends FetchOosState {}

final class FetchOosSuccess extends FetchOosState {
  final OOSEntity? entity;

  FetchOosSuccess(this.entity);
}

final class FetchOosFailure extends FetchOosState {
  final Failure failure;

  FetchOosFailure(this.failure);
}
