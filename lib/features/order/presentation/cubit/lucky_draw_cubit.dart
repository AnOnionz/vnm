import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:vnm/features/order/domain/usecases/get_lucky_draw_usecase.dart';

part 'lucky_draw_state.dart';

class LuckyDrawCubit extends Cubit<LuckyDrawState> {
  final GetLuckyDrawUsecase getLuckyDraw;
  LuckyDrawCubit(this.getLuckyDraw) : super(LuckyDrawInitial());

  Future<void> getLuckyDrawInfo(int attendanceId, int orderId) async {
    emit(LuckyDrawLoading());
    final result = await getLuckyDraw(
        LuckyDrawParams(attendanceId: attendanceId, orderId: orderId));
    result.fold(
      (failure) => emit(LuckyDrawFailured(failure)),
      (data) {
        if (data == null) {
          emit(LuckyDrawFailured(DataNullFailure()));
        } else {
          emit(LuckyDrawSuccessed(data));
        }
      },
    );
  }
}
