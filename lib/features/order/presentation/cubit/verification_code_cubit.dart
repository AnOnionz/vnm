import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';
import 'package:vnm/features/order/domain/entities/customer_verification_code_entity.dart';
import 'package:vnm/features/order/domain/entities/verification_code_entity.dart';
import 'package:vnm/features/order/domain/usecases/get_otp_usecase.dart';
import 'package:vnm/features/order/domain/usecases/send_otp_usecase.dart';

import '../../domain/entities/order_entity.dart';

part 'verification_code_state.dart';

class VerificationCodeCubit extends Cubit<VerificationCodeState> {
  final GetOtpUsecase getOtpUsecase;
  final SendOtpUsecase sendOtpUsecase;

  VerificationCodeCubit(this.getOtpUsecase, this.sendOtpUsecase)
      : super(VerificationCodeState.init());

  final NetworkTimeService _networkTimeService = Modular.get();

  Future<void> initial(
      {required List<CustomerInfo> fields, bool? force}) async {
    final customerVerificationCode = fields
        .firstWhereOrNull((element) => element.otpDeliveryId != null)
        ?.otpDeliveryId;
    if (customerVerificationCode != null || force == true) {
      emit(state.copyWith(
        customerVerificationCode:
            CustomerVerificationCodeEntity(id: customerVerificationCode),
        verified: true,
      ));
    }
  }

  Future<void> restart({bool? force}) async {
    if (force == true) {
      emit(state.copyWith(
        customerVerificationCode: CustomerVerificationCodeEntity(),
        verified: true,
      ));
      return;
    }
    emit(VerificationCodeState.init());
  }

  Future<void> getOtp(
      {required List<CustomerInfo> identifyFields,
      required int attendanceId,
      required int featureId,
      String? requestId,
      required VoidCallback onSuccess}) async {
    emit(state.copyWith(
      codeSending: true,
      verifyFailured: false,
      codeSendFailured: false,
      verifying: false,
      verificationCodeEntity: state.verificationCodeEntity,
    ));

    Result<VerificationCodeEntity?> execute;
    if (requestId == null) {
      execute = await getOtpUsecase(VerificationParams(
              customerIdentities: identifyFields,
              attendanceId: attendanceId,
              featureId: featureId))
          .withLoading();
    } else {
      execute = await getOtpUsecase(VerificationParams(
          customerIdentities: identifyFields,
          attendanceId: attendanceId,
          requestId: requestId,
          featureId: featureId));
    }
    execute.fold(
        (failure) => emit(state.copyWith(
            verificationCodeEntity: state.verificationCodeEntity,
            codeSendFailured: true,
            codeSending: false,
            failure: failure)), (data) async {
      if (data == null) {
        emit(state.copyWith(
            verificationCodeEntity: state.verificationCodeEntity,
            codeSendFailured: true,
            codeSending: false,
            failure: DataNullFailure()));
      } else {
        final now = await _networkTimeService.ntpDateTimeMs();

        final countDown =
            max(data.otpResendAvailableAt!.millisecondsSinceEpoch - now, 0);
        emit(state.copyWith(
            codeSendFailured: false,
            codeSend: true,
            codeSending: false,
            countDown: countDown,
            verificationCodeEntity: data));
        onSuccess();
      }
    });
  }

  Future<void> verifyCode(
      {required List<CustomerInfo> identifyFields,
      required String code,
      required int attendanceId,
      required int featureId}) async {
    emit(state.copyWith(
        verifying: true, verificationCodeEntity: state.verificationCodeEntity));
    final execute = await sendOtpUsecase(VerificationParams(
        customerIdentities: identifyFields,
        code: code,
        attendanceId: attendanceId,
        featureId: featureId));
    execute.fold(
        (failure) => emit(state.copyWith(
            verificationCodeEntity: state.verificationCodeEntity,
            verifyFailured: true,
            verifying: false,
            failure: failure)), (data) {
      if (data == null) {
        emit(state.copyWith(
            verificationCodeEntity: state.verificationCodeEntity,
            verifyFailured: true,
            verifying: false,
            failure: DataNullFailure()));
      } else {
        emit(state.copyWith(
            codeSendFailured: false,
            codeSending: false,
            verifying: false,
            verified: true,
            verificationCodeEntity: state.verificationCodeEntity,
            customerVerificationCode: data));
      }
    });
  }
}
