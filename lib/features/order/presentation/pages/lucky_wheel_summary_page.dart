import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/database/database.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/styles/theme.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/core/widgets/app_indicator.dart';
import 'package:vnm/core/widgets/button/flat.dart';
import 'package:vnm/core/widgets/data_load_error_widget.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/lucky_wheel_module.dart';
import 'package:vnm/features/order/presentation/bloc/order_bloc.dart';
import 'package:vnm/features/order/presentation/cubit/lucky_draw_cubit.dart';
import 'package:vnm/features/order/presentation/widgets/review/customer_row_info.dart';
import 'package:vnm/features/order/presentation/widgets/review/review_container.dart';
import 'package:vnm/features/order/presentation/widgets/review/review_gift_luckydraw.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';
import 'package:vnm/features/report/presentation/widgets/photo_item.dart';
import 'package:vnm/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:uuid/uuid.dart';

class LuckyWheelSummaryPage extends StatefulWidget {
  final GeneralFeatureData generalFeature;
  final OrderEntity order;
  final bool isEditing;
  const LuckyWheelSummaryPage(
      {super.key,
      required this.generalFeature,
      required this.order,
      this.isEditing = false});

  @override
  State<LuckyWheelSummaryPage> createState() => _LuckyWheelSummaryPageState();
}

class _LuckyWheelSummaryPageState extends State<LuckyWheelSummaryPage> {
  final db = Database.instance;
  final _luckyDrawCubit = Modular.get<LuckyDrawCubit>();
  final _orderBloc = Modular.get<OrderBloc>();

  late final featurePhotos = widget.generalFeature.feature.featurePhotos ?? [];

  late final List<PhotoEntity> _photos = List.from(widget.isEditing
      ? (widget.order.photos ?? [])
      : widget.order.localPhotos.toList());

  late final Map<FeaturePhoto, List<PhotoEntity>> _items = {};

  final ValueNotifier<bool> isWatermarking = ValueNotifier(false);
  late StreamSubscription<OrderState>? _orderSubscription;

  final prizes = <OrderPrizeEntity>[];
  final Map<Item, int> _gifts = {};

  bool get validate => _items.entries.every((item) {
        return switch (item.key.isRequired) {
          true => item.value
                  .where((element) => element.status != SyncStatus.isDeleted)
                  .length >=
              item.key.minimum!,
          false => true
        };
      });

  void fetchData() {
    _luckyDrawCubit.getLuckyDrawInfo(
        widget.generalFeature.general.attendance!.id!, widget.order.id!);
  }

  Future<void> saveData() async {
    if (ListEquality().equals(
        _items.entries.map((e) => e.value).expand((photos) => photos).toList(),
        widget.order.photos)) {
      final newOrder = widget.order.copyWith(prizes: prizes);
      db.addObject<OrderEntity>(newOrder);
      nextPage();
    } else {
      updateNewOrder();
    }
  }

  Future<void> updateNewOrder() async {
    final newOrder = widget.order.copyWith(
        photos: _items.entries
            .map((e) => e.value)
            .expand((photos) => photos)
            .toList(),
        prizes: prizes);

    _orderBloc.add(
        UpdateOrder(order: newOrder, feature: widget.generalFeature.feature));
  }

  void updatePrizes(List<CustomerLuckyDraw> customerLuckyDraws) {
    late final giftProceeds = customerLuckyDraws
        .map(
          (e) => e.prizeItems,
        )
        .expand((element) => element)
        .toList();

    customerLuckyDraws.forEachIndexed((index, gift) {
      if (gift.prizeResults.isNotEmpty) {
        gift.prizeResults.forEach((prize) {
          final prizeItem = giftProceeds.firstWhereOrNull(
            (element) => element.id == prize.prizeItemId,
          );
          if (prizeItem?.projectItem.item != null) {
            _gifts[prizeItem!.projectItem.item!] =
                (_gifts[prizeItem.projectItem.item!] ?? 0) + 1;
          }
        });
      }
    });
    if (_gifts.isNotEmpty) {
      _gifts.forEach((key, value) {
        prizes.add(OrderPrizeEntity(
          item: key,
          quantity: value,
        ));
      });
    }

    setState(() {});
  }

  void nextPage() {
    if (widget.isEditing == true) {
      context.nextReplacementRoute(LuckyWheelModule.editingSuccess,
          arguments: widget.generalFeature);
    } else {
      context.nextRoute(LuckyWheelModule.success,
          arguments: widget.generalFeature);
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
    _orderSubscription = _orderBloc.stream.listen((state) {
      if (state is OrderUpdateSuccess) {
        nextPage();
      }
      if (state is OrderUpdateFailure) {
        showFailure(
            title: 'Cập nhật thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình cập nhật hình ảnh',
            btnText: 'Thử lại',
            onPressed: () {
              updateNewOrder();
            });
      }
    });
  }

  @override
  void didChangeDependencies() {
    featurePhotos.forEach((featurePhoto) {
      final photos = _photos
          .where((element) => element.featurePhotoId == featurePhoto.id)
          .toList();
      _items[featurePhoto] = photos.map((e) => e.copyWith()).toList();
    });
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.generalFeature.feature.name ?? 'Ghi nhận đơn hàng',
          iconBack: SizedBox.shrink(),
          onBack: () {},
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 26.h),
          child: Column(
            children: [
              Expanded(
                  child: BlocConsumer<LuckyDrawCubit, LuckyDrawState>(
                bloc: _luckyDrawCubit,
                listener: (context, state) {
                  if (state is LuckyDrawSuccessed) {
                    updatePrizes(state.data.customerLuckyDraws);
                  }
                  if (state is LuckyDrawFailured) {
                    showFailure(
                      title: 'Tải dữ liệu thất bại',
                      icon: SvgPicture.asset(AppIcons.failure),
                      message: state.failure.message,
                      btnText: 'Thử lại',
                      onPressed: () async {
                        await Future.delayed(
                          300.milliseconds,
                          () => fetchData(),
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LuckyDrawSuccessed) {
                    return CustomScrollView(
                      physics: kPhysics,
                      slivers: [
                        if (widget.generalFeature.feature.featureOrder!
                                .hasCustomer ??
                            true)
                          SliverToBoxAdapter(
                            child: ReviewContainer(
                                margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Thông tin khách hàng',
                                      style: context.textTheme.subtitle1,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    for (final customerInfoField
                                        in state.data.customerInfoFields)
                                      CustomerRowInfo(
                                          label: customerInfoField.label,
                                          value: customerInfoField.value),
                                  ],
                                )),
                          ),
                        SliverToBoxAdapter(
                            child: ReviewGiftLuckyDraw(
                          title: 'Quà vòng quay may mắn',
                          customerLuckyDraws: state.data.customerLuckyDraws,
                        )),
                        SliverPadding(
                            padding: EdgeInsets.only(top: 2.h),
                            sliver: SliverList.builder(
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items.entries.elementAt(index);
                                return PhotoItem(
                                  entity: item.key,
                                  feature: widget.generalFeature.feature,
                                  photos: item.value,
                                  onAdded: (file) async {
                                    item.value.add(PhotoEntity(
                                      dataUuid: Uuid().v1(),
                                      dataTimestamp: file.dataTimestamp,
                                      path: file.path,
                                      featureId:
                                          widget.generalFeature.feature.id,
                                      attendanceId: widget.generalFeature
                                          .general.attendance!.id,
                                      featurePhotoId: item.key.id!,
                                    ));
                                    setState(() {});
                                  },
                                  onDeleted: (image) {
                                    if (image.id != null) {
                                      final photo = item.value.firstWhere(
                                          (element) =>
                                              element.dataUuid == image.uuid);
                                      photo.status = SyncStatus.isDeleted;
                                      photo.attendanceId = widget.generalFeature
                                          .general.attendance!.id;
                                      photo.featureId =
                                          widget.generalFeature.feature.id;
                                    } else {
                                      item.value.removeWhere((photo) =>
                                          photo.dataUuid == image.uuid);
                                    }
                                    setState(() {});
                                    print(_items);
                                  },
                                  isWatermark: item.key.isWatermarkRequired!,
                                  isWatermarking: item.key.isWatermarkRequired!
                                      ? isWatermarking
                                      : null,
                                );
                              },
                            ))
                      ],
                    );
                  }
                  if (state is LuckyDrawFailured) {
                    return Center(
                      child: DataLoadErrorWidget(onPressed: () => fetchData()),
                    );
                  }
                  return Center(child: AppIndicator());
                },
              )),
              BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
                bloc: _luckyDrawCubit,
                builder: (context, state) {
                  if (state is! LuckyDrawSuccessed) {
                    return SizedBox.shrink();
                  }
                  return Container(
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
                            child: ScheduleBuilder(
                              feature: widget.generalFeature.feature,
                              isValidateStart: false,
                              showBackground: false,
                              builder: (callback) => FlatButton(
                                onPressed: () => callback(saveData),
                                name: 'Hoàn thành',
                                color: AppColors.primary,
                                disableTextColor: AppColors.delRio,
                                disableColor: AppColors.potPourri,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
