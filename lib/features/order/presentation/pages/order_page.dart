import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/mixins/common.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/core/widgets/notifications.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/features/home/home_module.dart';
import 'package:vnm/features/order/domain/entities/customer_identity.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/history_exchange_module.dart';
import 'package:vnm/features/order/lucky_wheel_module.dart';
import 'package:vnm/features/order/order_module.dart';
import 'package:vnm/features/order/presentation/bloc/order_bloc.dart';
import 'package:vnm/features/order/presentation/cubit/cancel_order_cubit.dart';
import 'package:vnm/features/order/presentation/pages/purchase_page.dart';
import 'package:vnm/features/schedule/presentation/services/schedule_service.dart';
import 'package:vnm/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/button/flat.dart';
import '../../../../core/widgets/button/outline.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/data_feature_widget.dart';
import '../widgets/exchange_detail.dart';
import 'customer_with_limits_page.dart';
import 'exchange_page.dart';
import 'order_photo_page.dart';
import 'order_sampling_page.dart';

class OrderPage extends StatefulWidget {
  final GeneralFeatureData entity;
  final OrderEntity? order;
  const OrderPage({super.key, required this.entity, this.order});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final NetworkTimeService _networkTimeService =
      Modular.get<NetworkTimeService>();
  final ScheduleService _scheduleService = ScheduleService();
  final orderBloc = Modular.get<OrderBloc>();
  final cancelOrderCubit = Modular.get<CancelOrderCubit>();
  PageController controller = PageController();
  Completer<OrderEntity> _completer = Completer();
  late OrderEntity orderEntity;
  late List<Widget> _body = [];
  List<StepData> _steps = [];
  List<RemainingQuota> quotas = [];
  List<CustomerOrderHistory> customerOrderHistorys = [];

  late StreamSubscription<OrderState>? _orderSubscription;
  late StreamSubscription<CancelOrderState>? _cancelOrderSubscription;
  bool get isEditing => widget.order != null;
  int _curr = 0;

  bool isSummary = false;
  bool get isHasLuckyWheel => (orderEntity.exchanges ?? [])
      .any((element) => (element.exchangeProceeds ?? []).any(
            (e) => e.id == -1,
          ));

  @override
  void initState() {
    super.initState();
    _init();
    _orderSubscription = orderBloc.stream.listen((state) {
      if (state is OrderCreateSuccess) {
        if (isHasLuckyWheel) {
          context.nextReplacementRoute(LuckyWheelModule.route,
              arguments: [widget.entity, state.order, isEditing]);
        } else {
          context.nextRoute(OrderModule.success, arguments: widget.entity);
        }
      }
      if (state is OrderCreateFailure) {
        showFailure(
            title: 'Thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình tạo đơn',
            btnText: 'Thử lại',
            onPressed: () {
              orderBloc.add(CreateOrder(
                  order: orderEntity, feature: widget.entity.feature));
            });
      }
      if (state is OrderUpdateSuccess) {
        if (isHasLuckyWheel) {
          context.nextReplacementRoute(LuckyWheelModule.route,
              arguments: [widget.entity, state.order, isEditing]);
        } else {
          context.nextReplacementRoute(HistoryExchangeModule.updateSuccess,
              arguments: orderEntity);
        }
      }
      if (state is OrderUpdateFailure) {
        showFailure(
            title: 'Chỉnh sửa thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình chỉnh sửa',
            btnText: 'Thử lại',
            onPressed: () {
              orderBloc.add(UpdateOrder(
                  order: orderEntity, feature: widget.entity.feature));
            });
      }
    });
    _cancelOrderSubscription = cancelOrderCubit.stream.listen((state) {
      if (state is CancelOrderSuccess) {
        context.popUntil(HomeModule.route);
      }
      if (state is CancelOrderFailure) {
        showFailure(
            title: 'Huỷ đơn thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình huỷ đơn hàng',
            btnText: 'Thử lại',
            onPressed: () {
              cancelOrderCubit.cancelOrder(
                  feature: widget.entity.feature, order: orderEntity);
            });
      }
    });
    _scheduleService
        .checkSchedules(widget.entity.feature.schedules)
        .then((isValid) {
      if (!isValid) showSchedule();
    });
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    _cancelOrderSubscription?.cancel();
    super.dispose();
  }

  void onNext() {
    Fx.log(orderEntity);
    if (_curr == _steps.length - 1) {
      setState(() {
        isSummary = true;
      });
    } else {
      controller.nextPage(duration: 500.milliseconds, curve: Curves.ease);
    }
  }

  void onBack() {
    controller.previousPage(duration: 500.milliseconds, curve: Curves.ease);
  }

  void onSkip(StepData step) {
    switch (step.runtimeType) {
      case CustomerStep:
        orderEntity = orderEntity.copyWith(
            customerInfos: orderEntity.customerInfos ?? []);
        break;
      case PurchaseStep:
        orderEntity =
            orderEntity.copyWith(purchases: orderEntity.purchases ?? []);
        break;
      case ExchangeStep:
        orderEntity =
            orderEntity.copyWith(exchanges: orderEntity.exchanges ?? []);
        break;
      case SamplingStep:
        orderEntity =
            orderEntity.copyWith(samplings: orderEntity.samplings ?? []);
        break;
      case PhotoStep:
        orderEntity = orderEntity.copyWith(photos: orderEntity.photos ?? []);
        break;
    }
    setState(() {});
    onNext();
  }

  bool canSkip(StepData? step) {
    switch (step.runtimeType) {
      case CustomerStep:
        return (orderEntity.customerInfos ?? []).isNotEmpty;
      case PurchaseStep:
        return (orderEntity.purchases ?? []).isNotEmpty;
      case ExchangeStep:
        return (orderEntity.exchanges ?? []).isNotEmpty;
      case SamplingStep:
        return (orderEntity.samplings ?? []).isNotEmpty;
      case PhotoStep:
        return (orderEntity.photos ?? []).isNotEmpty;
      default:
        return false;
    }
  }

  bool isSkipHidden(StepData? step) {
    if (isSummary || _steps.isEmpty) return true;
    switch (step.runtimeType) {
      case CustomerStep:
        return widget.entity.feature.featureOrder!.isCustomerRequired ?? false;
      case PurchaseStep:
        return widget.entity.feature.featureOrder!.isPurchaseRequired ?? false;
      case ExchangeStep:
        return widget.entity.feature.featureOrder!.isExchangeRequired ?? false;
      case SamplingStep:
        return false;
      case PhotoStep:
        return widget.entity.feature.featureOrder!.isPhotoRequired ?? false;
    }
    return false;
  }

  Future<void> saveData() async {
    if (orderEntity.isEmpty()) {
      showFailure(
          title: 'Không thể hoàn thành đơn hàng',
          message: 'Yêu cầu cần ít nhất có 1 trường dữ liệu để tạo đơn',
          btnText: 'Ok');
      return;
    }

    if (orderEntity.id != null) {
      orderBloc
          .add(UpdateOrder(order: orderEntity, feature: widget.entity.feature));
    } else {
      orderBloc
          .add(CreateOrder(order: orderEntity, feature: widget.entity.feature));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: DefaultAppBar(
          onBack: isEditing
              ? () => context.pop()
              : () => showWarning(
                  title: 'Hủy đơn hàng hiện tại ?',
                  message:
                      'Đơn hàng hiện tại sẽ không được ghi nhận. Bạn có chắc muốn hủy đơn này ?',
                  icon: SvgPicture.asset(AppIcons.requestClose),
                  btnText: 'Huỷ đơn',
                  onPressed: () => cancelOrderCubit.cancelOrder(
                      feature: widget.entity.feature, order: orderEntity)),
          iconBack: SvgPicture.asset(AppIcons.closeRegular),
          title: widget.entity.feature.name!,
          action: Visibility(
            visible: !isSkipHidden(_steps.elementAtOrNull(_curr)),
            child: TextButton(
                onPressed: canSkip(_steps.elementAtOrNull(_curr))
                    ? () => onSkip(_steps[_curr])
                    : () => showWarning(
                        title: 'Xác nhận bỏ qua bước này',
                        message: 'Thông tin sẽ không được ghi nhận',
                        icon: SvgPicture.asset(AppIcons.requestSkip),
                        btnText: 'Bỏ qua',
                        onPressed: () {
                          onSkip(_steps[_curr]);
                        }),
                child: Text(
                  'Skip',
                  style: context.textTheme.body1,
                )),
          ),
        ),
        body: _completer.isCompleted
            ? IndexedStack(
                index: !isSummary ? 0 : 1,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 22.h),
                          margin: EdgeInsets.fromLTRB(16.w, 35.h, 16.w, 8.h),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.sqr)),
                          child: CustomStepper(
                            steps: _steps,
                            order: orderEntity,
                            current: _curr,
                            ignoredColor: 'FFC737'.toColor(),
                            primaryColor: '0043CE'.toColor(),
                          )),
                      Expanded(
                          child: DataFeature(
                        data: widget.entity,
                        order: orderEntity,
                        quotas: quotas,
                        customerOrderHistorys: customerOrderHistorys,
                        child: PageView(
                          children: _body,
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          onPageChanged: (num) {
                            setState(() {
                              _curr = num;
                            });
                          },
                        ),
                      )),
                    ],
                  ),
                  ZoomIn(
                    duration: 600.milliseconds,
                    child: Padding(
                      padding: EdgeInsets.only(top: 26.h),
                      child: Column(
                        children: [
                          Expanded(
                              child: ExchangeDetail(
                                  order: orderEntity,
                                  feature: widget.entity.feature)),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, -2),
                                      blurRadius: 25,
                                      color: '000000'.toColor(0.15))
                                ]),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: OutlineButton(
                                    onPressed: () {
                                      setState(() {
                                        isSummary = false;
                                        controller = controller =
                                            PageController(initialPage: _curr);
                                      });
                                    },
                                    name: 'Quay lại',
                                    color: AppColors.primary,
                                  )),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: ScheduleBuilder(
                                      feature: widget.entity.feature,
                                      isValidateStart: false,
                                      showBackground: false,
                                      builder: (callback) => FlatButton(
                                        onPressed: () => callback(saveData),
                                        name: isHasLuckyWheel
                                            ? 'Tiếp tục'
                                            : 'Hoàn thành',
                                        color: AppColors.primary,
                                        disableTextColor: AppColors.delRio,
                                        disableColor: AppColors.potPourri,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : SizedBox.shrink(),
      ),
    );
  }

  Future<void> _init() async {
    int index = 0;
    final time = await _networkTimeService.ntpDateTime();

    if (isEditing) {
      orderEntity = widget.order!;
      orderEntity.attendanceId = widget.entity.general.attendance!.id;
      orderEntity.featureId = widget.entity.feature.id;
      quotas = orderEntity.remainingQuotas ?? [];
    } else {
      orderEntity = OrderEntity(
        dataUuid: Uuid().v1(),
        dataTimestamp: time,
        attendanceId: widget.entity.general.attendance!.id,
        featureId: widget.entity.feature.id,
      );
    }

    if (widget.entity.feature.featureOrder?.hasCustomer == true) {
      _steps.add(
        CustomerStep(name: 'K.Hàng', index: index++),
      );
      _body.add(OrderCustomerLimitsPage(
        key: PageStorageKey('customer'),
        onNext: onNext,
        onSaveData: (
          customers,
          newQuotas,
          customerOrderHistorys,
        ) {
          setState(() {
            orderEntity = orderEntity.copyWith(customerInfos: customers);
            quotas = newQuotas;
            customerOrderHistorys = customerOrderHistorys;
          });
        },
      ));
    }
    if (widget.entity.feature.featureOrder?.hasPurchase == true) {
      _steps.add(PurchaseStep(name: 'Sản phẩm', index: index++));
      _body.add(OrderPurchasePage(
        key: PageStorageKey('product'),
        onBack: onBack,
        onNext: onNext,
        onSaveData: (purchases) {
          setState(() {
            orderEntity = orderEntity.copyWith(purchases: purchases);
          });
        },
      ));
    }
    if (widget.entity.feature.featureOrder?.hasExchange == true) {
      _steps.add(ExchangeStep(
        name: 'Đổi quà',
        index: index++,
      ));
      _body.add(OrderExchangePage(
        key: PageStorageKey('exchange'),
        onBack: onBack,
        onNext: onNext,
        onSaveData: (exchanges) {
          setState(() {
            orderEntity = orderEntity.copyWith(exchanges: exchanges);
          });
        },
      ));
    }
    if (widget.entity.feature.featureOrder?.hasSampling == true) {
      _steps.add(SamplingStep(name: 'Sampling', index: index++));
      _body.add(OrderSamplingPage(
        key: PageStorageKey('sampling'),
        onBack: onBack,
        onNext: onNext,
        onSaveData: (samplings) {
          setState(() {
            orderEntity = orderEntity.copyWith(samplings: samplings);
          });
        },
      ));
    }
    if (widget.entity.feature.featureOrder?.hasPhoto == true) {
      _steps.add(PhotoStep(name: 'Chụp hình', index: index++));
      _body.add(OrderPhotoPage(
        key: PageStorageKey('order_photo'),
        onBack: onBack,
        onNext: onNext,
        onSaveData: (photos) {
          setState(() {
            orderEntity = orderEntity.copyWith(photos: photos);
          });
        },
      ));
    }

    setState(() {});
    _completer.complete(orderEntity);
  }
}
