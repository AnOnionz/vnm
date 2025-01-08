part of 'lucky_draw_cubit.dart';

sealed class LuckyDrawState extends Equatable {
  const LuckyDrawState();

  @override
  List<Object> get props => [];
}

final class LuckyDrawInitial extends LuckyDrawState {}

final class LuckyDrawLoading extends LuckyDrawState {}

final class LuckyDrawSuccessed extends LuckyDrawState {
  final CustomerInfoWithLuckyDrawEntity data;

  LuckyDrawSuccessed(this.data);
}

final class LuckyDrawFailured extends LuckyDrawState {
  final Failure failure;

  LuckyDrawFailured(this.failure);
}
