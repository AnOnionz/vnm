part of 'generic_data_cubit.dart';

sealed class GenericDataState {
  const GenericDataState();
}

final class GenericDataInitial extends GenericDataState {}

final class GenericDataLoading extends GenericDataState {}

final class GenericDataSuccess extends GenericDataState {
  final NumericSheetEntity? entity;

  GenericDataSuccess(this.entity);
}

final class GenericDataFailure extends GenericDataState {
  final Failure failure;

  GenericDataFailure(this.failure);
}
