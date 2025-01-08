import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/features/order/domain/entities/customer_identity.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/identify_customer_limit_usecase.dart';
import '../../domain/usecases/identify_customer_usecase.dart';

part 'identify_with_limits_state.dart';

class IdentifyWithLimitsCubit extends Cubit<IdentifyWithLimitsState> {
  final IdentifyCustomerWithLimitsUsecase identifyCustomerWithLimits;
  IdentifyWithLimitsCubit(this.identifyCustomerWithLimits)
      : super(IdentifyWithLimitsInitial());

  Future<void> identify(
      {required List<CustomerInfo> identifyFields,
      required int attendanceId,
      int? excludeOrderId,
      required int featureId}) async {
    emit(IdentifyWithLimitsLoading());
    final execute = await identifyCustomerWithLimits(IdentifyCustomerParams(
        customerIdentities: identifyFields,
        attendanceId: attendanceId,
        excludeOrderId: excludeOrderId,
        featureId: featureId));
    execute.fold((failure) => emit(IdentifyWithLimitsFailure(failure)),
        (data) => emit(IdentifyWithLimitsSuccess(data)));
  }

  Future<void> setIdentify() async {
    emit(IdentifyWithLimitsSuccess(CustomerIdentity.empty()));
  }
}
