// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'verification_code_cubit.dart';

class VerificationCodeState extends Equatable {
  const VerificationCodeState(
      {this.verificationCodeEntity,
      this.customerVerificationCode,
      this.failure,
      this.verifying = false,
      this.verified = false,
      this.verifyFailured = false,
      this.codeSending = false,
      this.codeSend = false,
      this.codeSendFailured = false,
      this.countDown = 0});

  final VerificationCodeEntity? verificationCodeEntity;
  final CustomerVerificationCodeEntity? customerVerificationCode;
  final Failure? failure;
  final bool verifying;
  final bool verified;
  final bool verifyFailured;
  final bool codeSending;
  final bool codeSend;
  final bool codeSendFailured;
  final int countDown;

  VerificationCodeState.init() : this();

  @override
  List<Object?> get props => [
        verifying,
        verified,
        verifyFailured,
        codeSending,
        codeSend,
        codeSendFailured,
        failure,
        countDown,
        verificationCodeEntity,
        customerVerificationCode
      ];

  VerificationCodeState copyWith(
      {VerificationCodeEntity? verificationCodeEntity,
      CustomerVerificationCodeEntity? customerVerificationCode,
      Failure? failure,
      bool? verifying,
      bool? verified,
      bool? verifyFailured,
      bool? codeSending,
      bool? codeSend,
      bool? codeSendFailured,
      int? countDown}) {
    return VerificationCodeState(
      verificationCodeEntity: verificationCodeEntity,
      customerVerificationCode: customerVerificationCode,
      failure: failure,
      countDown: countDown ?? this.countDown,
      verifying: verifying ?? this.verifying,
      verified: verified ?? this.verified,
      verifyFailured: verifyFailured ?? this.verifyFailured,
      codeSending: codeSending ?? this.codeSending,
      codeSend: codeSend ?? this.codeSend,
      codeSendFailured: codeSendFailured ?? this.codeSendFailured,
    );
  }

  @override
  String toString() {
    return 'VerificationCodeState(verificationCodeEntity :$verificationCodeEntity, customerVerificationCode: $customerVerificationCode,countDown: $countDown, verifying: $verifying, verified: $verified, verifyFailured: $verifyFailured, codeSending: $codeSending, codeSend: $codeSend, codeSendFailured: $codeSendFailured, failure: $failure    )';
  }
}
