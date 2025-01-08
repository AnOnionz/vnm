import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/order/domain/usecases/identify_customer_usecase.dart';

import '../../domain/entities/order_entity.dart';

part 'identify_state.dart';

class IdentifyCubit extends Cubit<IdentifyState> {
  final IdentifyCustomerUsecase identifyCustomer;

  IdentifyCubit(this.identifyCustomer) : super(IdentifyInitial());

  Future<void> identify(
      {required List<CustomerInfo> identifyFields,
      required int attendanceId,
      required int featureId}) async {
    emit(IdentifyLoading());
    final execute = await identifyCustomer(IdentifyCustomerParams(
        customerIdentities: identifyFields,
        attendanceId: attendanceId,
        featureId: featureId));
    execute.fold((failure) => emit(IdentifyFailure(failure)),
        (data) => emit(IdentifySuccess(data)));
  }

  Future<void> setIdentify() async {
    emit(IdentifySuccess([]));
  }
}
