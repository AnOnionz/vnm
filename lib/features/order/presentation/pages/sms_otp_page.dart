import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/mixins/extension/context_ext.dart';
import 'package:fms/core/mixins/extension/string_ext.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/presentation/cubit/verification_code_cubit.dart';
import 'package:pinput/pinput.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/button/outline.dart';

class SmsOTPPage extends StatefulWidget {
  final VerificationCodeCubit verificationCodeCubit;
  final List<CustomerInfo> identifyFields;
  final int attendanceId;
  final int featureId;
  final int countDown;
  const SmsOTPPage(
      {super.key,
      required this.verificationCodeCubit,
      required this.identifyFields,
      required this.attendanceId,
      required this.featureId,
      required this.countDown});

  @override
  State<SmsOTPPage> createState() => _SmsOTPPageState();
}

class _SmsOTPPageState extends State<SmsOTPPage> {
  int get length =>
      widget.verificationCodeCubit.state.verificationCodeEntity?.otpLength ?? 4;
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  late StopWatchTimer _stopWatchTimer;
  late bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    _stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countDown, presetMillisecond: widget.countDown);
    _stopWatchTimer.onStartTimer();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _stopWatchTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: context.textTheme.h2?.copyWith(color: AppColors.usafaBlue),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: '#E7EDF3'.toColor(),
      ),
    );

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: DefaultAppBar(
            title: 'Xác thực OTP',
            onBack: () => context.pop(isSuccess),
          ),
          body: Container(
            padding: EdgeInsets.all(24.w),
            margin: EdgeInsets.fromLTRB(16.w, 35.h, 16.w, 8.h),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.sqr),
                boxShadow: [
                  BoxShadow(
                      color: '#04060F0D'.toColor(),
                      blurRadius: 60,
                      offset: Offset(0, 4))
                ]),
            child: BlocConsumer<VerificationCodeCubit, VerificationCodeState>(
              bloc: widget.verificationCodeCubit,
              listener: (context, state) {
                if (state.verifyFailured && state.failure != null) {
                  if (formKey.currentState?.validate() == false) {
                    pinController.clear();
                  }
                }
                if (!state.verifyFailured && state.failure == null) {
                  formKey.currentState?.validate();
                }
              },
              builder: (context, state) {
                if (state.verified) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 40.h),
                      SvgPicture.asset(AppIcons.orderSuccess),
                      Padding(
                        padding: EdgeInsets.only(top: 20.w, bottom: 10.w),
                        child: Text('Thành công', style: context.textTheme.h2),
                      ),
                      Text('Số điện thoại của bạn đã được xác thực',
                          textAlign: TextAlign.center,
                          style: context.textTheme.body1
                              ?.copyWith(color: AppColors.nobel)),
                      Padding(
                        padding: EdgeInsets.only(top: 20.w, bottom: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlineButton(
                                  onPressed: () => context.pop(isSuccess),
                                  name: 'Tiếp tục ghi đơn',
                                  color: AppColors.royalBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Form(
                    key: formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.w),
                        child: Text(
                          'Xác thực số điện thoại',
                          style: context.textTheme.h2
                              ?.copyWith(color: AppColors.darkGunmetal),
                        ),
                      ),
                      Text(
                        'Vui lòng nhập mã OTP được gửi qua SMS thông qua số điện thoại đã cung cấp',
                        textAlign: TextAlign.center,
                        style: context.textTheme.subtitle1?.copyWith(
                            color: '#606268'.toColor(), height: 24.sp / 16.sp),
                      ),
                      Text(
                        (widget.verificationCodeCubit.state
                                    .verificationCodeEntity?.recipient ??
                                '')
                            .replaceFirst(RegExp(r'0'), '+84'),
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: AppColors.darkGunmetal),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 52.w),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            controller: pinController,
                            keyboardType: TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'([0-9])'))
                            ],
                            focusNode: focusNode,
                            enabled:
                                !widget.verificationCodeCubit.state.codeSending,
                            autofocus: true,
                            length: length,
                            toolbarEnabled: false,
                            separatorBuilder: (index) => SizedBox(width: 8.w),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration?.copyWith(
                                border: Border.all(color: '#0085FF'.toColor()),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration?.copyWith(
                                border: Border.all(
                                    color: AppColors.brickRed.withAlpha(95)),
                              ),
                            ),
                            errorText: state.failure?.message ??
                                'Mã OTP không chính xác',
                            errorBuilder: (errorText, pin) {
                              return Padding(
                                padding: EdgeInsets.only(top: 16.w),
                                child: errorText != null
                                    ? Text(
                                        errorText,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.caption2
                                            ?.copyWith(color: AppColors.red),
                                      )
                                    : SizedBox.shrink(),
                              );
                            },
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                color: '#E7EDF3'.toColor(),
                              ),
                            ),
                            followingPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                color: '#E7EDF3'.toColor(),
                              ),
                            ),
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: AppColors.usafaBlue,
                                ),
                              ],
                            ),
                            validator: (value) {
                              print(widget.verificationCodeCubit.state.failure
                                  ?.message);
                              return widget
                                  .verificationCodeCubit.state.failure?.message;
                            },
                            onCompleted: (value) async {
                              widget.verificationCodeCubit.verifyCode(
                                  identifyFields: widget.identifyFields,
                                  code: value,
                                  attendanceId: widget.attendanceId,
                                  featureId: widget.featureId);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 26.w),
                        child: Text(
                          'Bạn chưa nhận được mã OTP ?',
                          style: context.textTheme.subtitle1
                              ?.copyWith(color: AppColors.usafaBlue),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 4.w, bottom: 8.w),
                          child: StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData: 0,
                            builder: (context, snap) {
                              final value = snap.data!;
                              if (value < 1000) {
                                return InkWell(
                                  onTap: widget.verificationCodeCubit.state
                                          .codeSending
                                      ? null
                                      : () {
                                          widget.verificationCodeCubit.getOtp(
                                            identifyFields:
                                                widget.identifyFields,
                                            attendanceId: widget.attendanceId,
                                            featureId: widget.featureId,
                                            requestId: widget
                                                .verificationCodeCubit
                                                .state
                                                .verificationCodeEntity
                                                ?.requestId,
                                            onSuccess: () async {
                                              _stopWatchTimer.onResetTimer();
                                              _stopWatchTimer = StopWatchTimer(
                                                  mode: StopWatchMode.countDown,
                                                  presetMillisecond: widget
                                                      .verificationCodeCubit
                                                      .state
                                                      .countDown);
                                              _stopWatchTimer.onStartTimer();
                                            },
                                          );
                                        },
                                  child: Text(
                                    'Gửi lại',
                                    style: context.textTheme.subtitle1
                                        ?.copyWith(
                                            color: AppColors.usafaBlue,
                                            decorationColor:
                                                AppColors.usafaBlue,
                                            decoration:
                                                TextDecoration.underline),
                                  ),
                                );
                              }
                              final displayTime = StopWatchTimer.getDisplayTime(
                                  value,
                                  hours: false,
                                  milliSecond: false);
                              return Text(
                                displayTime,
                                style: context.textTheme.subtitle1
                                    ?.copyWith(color: '#F58229'.toColor()),
                              );
                            },
                          )),
                    ]));
              },
            ),
          )),
    );
  }
}
