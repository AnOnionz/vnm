import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/app_indicator.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/features/order/domain/entities/customer_identity.dart';
import 'package:vnm/features/order/order_module.dart';
import 'package:vnm/features/order/presentation/cubit/identify_with_limits_cubit.dart';
import 'package:vnm/features/order/presentation/cubit/verification_code_cubit.dart';
import 'package:vnm/features/order/presentation/widgets/bottom_buttons.dart';
import 'package:vnm/features/order/presentation/widgets/customer/info_form.dart';
import 'package:vnm/features/order/presentation/widgets/data_feature_widget.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/styles/theme.dart';
import '../../../../core/widgets/notifications.dart';
import '../../../general/domain/entities/config_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../widgets/customer/identity_customer_form.dart';
import '../widgets/history/history_customer.dart';

typedef VerifyCodeRecord = ({bool isVerifyCode, String? identify});

class OrderCustomerLimitsPage extends StatefulWidget {
  final VoidCallback onNext;
  final void Function(
    List<CustomerInfo> customers,
    List<RemainingQuota> quotas,
    List<CustomerOrderHistory> customerOrderHistorys,
  ) onSaveData;

  const OrderCustomerLimitsPage({
    super.key,
    required this.onNext,
    required this.onSaveData,
  });

  @override
  State<OrderCustomerLimitsPage> createState() =>
      _OrderCustomerLimitsPageState();
}

class _OrderCustomerLimitsPageState extends State<OrderCustomerLimitsPage> {
  final _identifyCubit = Modular.get<IdentifyWithLimitsCubit>();
  final _verificationCodeCubit = Modular.get<VerificationCodeCubit>();
  final _formKey = GlobalKey<FormState>();
  late final attendanceId =
      DataFeature.of(context).data.general.attendance!.id!;
  late final featureId = DataFeature.of(context).data.feature.id!;
  late final featureCustomers =
      (DataFeature.of(context).data.feature.featureCustomers ?? [])
          .sorted((a, b) => a.ordinal! - b.ordinal!);

  late final List<CustomerInfo> customerInfos = List<CustomerInfo>.from(
      DataFeature.of(context).order.customerInfos ?? []);

  late List<RemainingQuota> quotas =
      List<RemainingQuota>.from(DataFeature.of(context).quotas);

  late List<CustomerOrderHistory> customerOrderHistorys =
      List<CustomerOrderHistory>.from(
          DataFeature.of(context).customerOrderHistorys);

  Map<FeatureCustomer, CustomerInfo> _identityFields = {};
  Map<FeatureCustomer, CustomerInfo> _infomationFields = {};
  late final hasExchange =
      DataFeature.of(context).data.feature.featureOrder?.hasExchange == true;
  bool get validate =>
      validateFields(_identityFields) && validateFields(_infomationFields);

  bool validateFields(Map<FeatureCustomer, CustomerInfo> fields) {
    return !fields.entries.any((field) {
      if (field.key.isRequired!) {
        return field.value.value.isEmptyOrNull &&
            (field.value.options == null || field.value.options!.isEmpty);
      }
      return false;
    });
  }

  late bool isOldCustomer = DataFeature.of(context).order.id != null;
  bool get isHasIdentity => _identityFields.isNotEmpty;
  bool get isQuotaOut => quotas.any((element) =>
      element.type == QuotaType.order && (element.remainingQuantity ?? 0) <= 0);

  bool get isVerify =>
      isRequireVerifyCode ? _verificationCodeCubit.state.verified : true;

  bool isChangedIdentity = false;
  bool isShowVerifyCode = false;
  bool isRequireVerifyCode = false;

  MapEntry<FeatureCustomer, CustomerInfo>? identity = null;

  @override
  void didChangeDependencies() {
    featureCustomers.forEach((featureCustomer) {
      final customerInfo = customerInfos.firstWhereOrNull(
          (element) => element.featureCustomerId == featureCustomer.id);
      if (featureCustomer.isIdentity == true) {
        _identityFields[featureCustomer] = customerInfo ??
            CustomerInfo(
              featureCustomerId: featureCustomer.id,
            );
      } else {
        _infomationFields[featureCustomer] = customerInfo != null
            ? customerInfo.copyWith()
            : CustomerInfo(
                featureCustomerId: featureCustomer.id,
              );
      }
    });

    if (!isHasIdentity || customerInfos.length > 0) {
      _identifyCubit.setIdentify();
    }
    updateVerification();
    _verificationCodeCubit.initial(fields: customerInfos);
    setState(() {});
    super.didChangeDependencies();
  }

  bool isSameAsIdentity(Map<FeatureCustomer, CustomerInfo> fields) {
    return _identityFields.valuesList().containsAll(fields.valuesList());
  }

  void _handleCallback(CustomerIdentity customer) {
    _infomationFields.entries.forEach((field) {
      final customerInfo = customer.customerInfos.firstWhereOrNull((element) =>
          element.featureCustomerId == field.value.featureCustomerId);
      if (customerInfo != null) {
        _infomationFields[field.key] = customerInfo;
      } else {
        _infomationFields[field.key] = CustomerInfo(
          featureCustomerId: _infomationFields[field.key]!.featureCustomerId,
        );
      }
    });
    isOldCustomer = customer.customerInfos.isNotEmpty;
    quotas = customer.remainingQuotas;
    customerOrderHistorys = customer.customerOrderHistorys;
    isChangedIdentity = false;
    updateVerification();
    setState(() {});
    _verificationCodeCubit.restart(force: isOldCustomer);
    final orderRemaining = customer.remainingQuotas
        .firstWhereOrNull((element) => element.type == QuotaType.order);

    if (orderRemaining != null &&
        (orderRemaining.remainingQuantity ?? 0) <= 0) {
      showRemainingQuotas(remainingQuota: orderRemaining);
      return;
    }

    final exchangeRemaining = customer.remainingQuotas
        .firstWhereOrNull((element) => element.type == QuotaType.exchange);
    if (exchangeRemaining != null && hasExchange) {
      showRemainingQuotas(remainingQuota: exchangeRemaining);
      return;
    }
  }

  void updateVerification() {
    isShowVerifyCode = _identityFields.entries.any(
      (entry) {
        final value = entry.value.value;
        final verification = entry.key.verification;
        if (verification != null) {
          if (value != null) {
            identity = entry;
            if (verification.mode == VerificationMode.all_customers) {
              isRequireVerifyCode = verification.isRequired ?? false;
              return true;
            }
            if (verification.mode == VerificationMode.existing_customer_only &&
                isOldCustomer) {
              isRequireVerifyCode = verification.isRequired ?? false;
              return true;
            }
            if (verification.mode == VerificationMode.new_customer_only &&
                !isOldCustomer) {
              isRequireVerifyCode = verification.isRequired ?? false;
              return true;
            }
          }
        }
        return false;
      },
    );
  }

  void getOTP() {
    _verificationCodeCubit.getOtp(
        onSuccess: () async {
          final success =
              await context.nextRoute(OrderModule.smsOTP, arguments: [
            _verificationCodeCubit,
            _identityFields.valuesList(),
            attendanceId,
            featureId,
            _verificationCodeCubit.state.countDown
          ]);

          if (success == true) {
            isShowVerifyCode = true;
          }

          setState(() {});
        },
        identifyFields: _identityFields.entries.map((e) => e.value).toList(),
        attendanceId: attendanceId,
        featureId: featureId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
              child: CustomScrollView(
            physics: kPhysics,
            slivers: [
              if (isHasIdentity)
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
                    margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.sqr)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Thông tin định danh khách hàng',
                                style: context.textTheme.subtitle1,
                              ),
                              // SvgPicture.asset(AppIcons.barcode)
                            ],
                          ),
                        ),
                        IdentityCustomerForm(
                          fields: _identityFields,
                          identifyCubit: _identifyCubit,
                          onIdentify: (fields) {
                            fields.forEach((key, value) {
                              _identityFields[key] = value.copyWith();
                            });
                          },
                          onFieldChanged: (fields) {
                            setState(() {
                              isChangedIdentity = !isSameAsIdentity(fields);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: BlocConsumer<IdentifyWithLimitsCubit,
                    IdentifyWithLimitsState>(
                  bloc: _identifyCubit,
                  listener: (context, state) {
                    if (state is IdentifyWithLimitsSuccess) {
                      _handleCallback(state.customer);
                    }
                  },
                  builder: (context, state) {
                    if (state is IdentifyWithLimitsLoading) {
                      return Container(
                        padding: EdgeInsets.all(24.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.sqr)),
                        child: AppIndicator(),
                      );
                    }
                    if (state is IdentifyWithLimitsSuccess) {
                      return Container(
                        padding: EdgeInsets.all(24.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.sqr)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Thông tin khách hàng',
                                    style: context.textTheme.subtitle1,
                                  ),
                                  Builder(builder: (context) {
                                    return Text(
                                      isOldCustomer ? 'khách cũ' : 'khách mới',
                                      style: context.textTheme.caption1
                                          ?.copyWith(
                                              color: isOldCustomer
                                                  ? AppColors.primary
                                                  : AppColors.royalBlue),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            InfomationForm(
                              formKey: _formKey,
                              fields: _infomationFields,
                              onFieldChanged: (newFields) {
                                print(validateFields(_infomationFields));
                                setState(() {
                                  _infomationFields = newFields;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              if (isShowVerifyCode)
                SliverToBoxAdapter(
                    child: BlocBuilder<IdentifyWithLimitsCubit,
                        IdentifyWithLimitsState>(
                  bloc: _identifyCubit,
                  builder: (context, state) {
                    if (state is IdentifyWithLimitsSuccess) {
                      if (identity == null) return SizedBox.shrink();
                      return Container(
                        padding: EdgeInsets.all(24.h),
                        margin: EdgeInsets.only(
                            left: 16.w, right: 16.w, bottom: 16.w),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.sqr)),
                        child: BlocConsumer<VerificationCodeCubit,
                            VerificationCodeState>(
                          bloc: _verificationCodeCubit,
                          listener: (context, state) {
                            if (state.failure != null) {
                              if (state.codeSendFailured) {
                                if (state.failure is SocketFailure) {
                                  showInternetFailure();
                                } else {
                                  showFailure(
                                      title: 'Gửi mã OTP thất bại',
                                      icon: SvgPicture.asset(AppIcons.failure),
                                      message: state.failure!.message ??
                                          'Phát sinh lỗi, Vui lòng kiểm tra lại kết nối mạng',
                                      btnText: 'Thử lại',
                                      onPressed: () {
                                        getOTP();
                                      });
                                }
                              }
                              if (state.verifyFailured &&
                                  state.failure is SocketFailure) {
                                showInternetFailure();
                              }
                            }
                          },
                          builder: (context, state) {
                            return InkWell(
                              onTap: state.verified || state.codeSending
                                  ? null
                                  : () {
                                      getOTP();
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                    color:
                                        (state.verified ? '#D9F1FF' : '#FFE8DC')
                                            .toColor(),
                                    borderRadius: BorderRadius.circular(4.sqr)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (state.verified
                                          ? 'Đã xác thực OTP'
                                          : 'Vui lòng xác thực OTP'),
                                      style: context.textTheme.button2
                                          ?.copyWith(
                                              color: state.verified
                                                  ? '#1380FF'.toColor()
                                                  : AppColors.primary),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                )),
              if (customerOrderHistorys.isNotEmpty)
                HistoryCustomer(customerOrderHistorys: customerOrderHistorys)
            ],
          )),
          Container(
            decoration: BoxDecoration(color: AppColors.white, boxShadow: [
              BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 25,
                  color: AppColors.black.withOpacity(0.15))
            ]),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: BottomButtons(
                  onBack: null,
                  onNext: _identifyCubit.state is IdentifyWithLimitsSuccess &&
                          validate &&
                          !isChangedIdentity &&
                          !isQuotaOut &&
                          isVerify
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            List<CustomerInfo> customers;
                            if (identity != null) {
                              customers =
                                  Map<FeatureCustomer, CustomerInfo>.from(
                                          _identityFields)
                                      .updateT(
                                        identity!.key,
                                        (value) => value.copyWith(
                                            otpDeliveryId:
                                                _verificationCodeCubit
                                                    .state
                                                    .customerVerificationCode
                                                    ?.id),
                                      )
                                      .addAllT(_infomationFields)
                                      .entries
                                      .map((e) => e.value)
                                      .toList();
                            } else {
                              customers =
                                  Map<FeatureCustomer, CustomerInfo>.from(
                                          _identityFields)
                                      .addAllT(_infomationFields)
                                      .entries
                                      .map((e) => e.value)
                                      .toList();
                            }
                            widget.onSaveData(
                              customers,
                              quotas,
                              customerOrderHistorys,
                            );
                            widget.onNext();
                          }
                        }
                      : null,
                )),
          )
        ],
      ),
    );
  }
}
