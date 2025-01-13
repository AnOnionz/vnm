import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/styles/theme.dart';
import 'package:fms/core/widgets/app_bar.dart';
import 'package:fms/core/widgets/app_indicator.dart';
import 'package:fms/core/widgets/button/flat.dart';
import 'package:fms/core/widgets/data_load_error_widget.dart';
import 'package:fms/core/widgets/notifications.dart';
import 'package:fms/core/widgets/popup.dart';
import 'package:fms/core/widgets/quantity_field_item.dart';
import 'package:fms/core/widgets/sliver_search_widget.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/home/domain/entities/general_item_data.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';
import 'package:fms/features/oos/presentation/cubit/fetch_oos_cubit.dart';
import 'package:fms/features/oos/presentation/cubit/oos_cubit.dart';
import 'package:fms/features/oos/presentation/widgets/oos_type_widget.dart';
import 'package:fms/features/schedule/presentation/widgets/schedule_builder.dart';

class OosPage extends StatefulWidget {
  final GeneralFeatureData entity;
  const OosPage({super.key, required this.entity});

  @override
  State<OosPage> createState() => _OosPageState();
}

class _OosPageState extends State<OosPage> {
  final OosCubit _oosCubit = Modular.get();
  final FetchOosCubit _fetchOosCubit = Modular.get();
  StreamSubscription<OosState>? oosSubscription;
  late final featureOosProducts =
      (widget.entity.feature.featureOosProducts ?? [])
          .sorted((a, b) => a.ordinal! - b.ordinal!);
  late List<FeatureQuantity> _featureOosProductsValid = featureOosProducts;
  late final featureOosZones = (widget.entity.feature.featureOosZones ?? [])
      .sorted((a, b) => a.ordinal! - b.ordinal!);
  OOSEntity? oosEntity = null;
  OOSEntity? lastOosEntity = null;
  FeatureOosZone? currentZone;

  bool get isActive =>
      currentZone != null &&
      oosEntity?.status == SyncStatus.isNoSynced &&
      oosEntity!.values.any((value) => value.value != null);

  @override
  void initState() {
    super.initState();
    fetchData();
    oosSubscription = _oosCubit.stream.listen((state) {
      if (state is OosSuccess) {
        showSuccess(title: 'Lưu thành công');
        setState(() {
          oosEntity = state.entity;
        });
      }
      if (state is OosFailure) {
        showFailure(
            title: 'Lưu thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message:
                state.failure.message ?? 'Phát sinh lỗi trong quá trình lưu',
            btnText: 'Thử lại',
            onPressed: () {
              saveData();
            });
      }
    });
  }

  @override
  void dispose() {
    oosSubscription?.cancel();
    super.dispose();
  }

  void fetchData() {
    _fetchOosCubit.fetchData(feature: widget.entity.feature);
  }

  void saveData() {
    FocusManager.instance.primaryFocus?.unfocus();
    _oosCubit.saveData(
        entity: oosEntity!.copyWith(featureOosZoneId: currentZone!.id),
        feature: widget.entity.feature);
  }

  Future<void> onFetchSuccess(OOSEntity? data) async {
    if (data != null) {
      oosEntity = data;
      lastOosEntity = oosEntity;
      if (data.featureOosZoneId != null) {
        currentZone = featureOosZones
            .firstWhereOrNull((element) => element.id == data.featureOosZoneId);
      }
    } else {
      final oosData = OOSEntity(
          values: featureOosProducts
              .map((featureOosProduct) => OOSStatusValueEntity(
                    featureOosProductId: featureOosProduct.id,
                  ))
              .toList());
      oosEntity = oosData;
      lastOosEntity = oosEntity;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.entity.feature.name ?? 'OOS',
          action: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => showOosAbout(),
                child: SvgPicture.asset(AppIcons.info)),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocConsumer<FetchOosCubit, FetchOosState>(
                  bloc: _fetchOosCubit,
                  listener: (context, state) {
                    if (state is FetchOosSuccess) {
                      onFetchSuccess(state.entity);
                    }
                    if (state is FetchOosFailure) {
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
                    if (state is FetchOosSuccess) {
                      return CustomScrollView(
                        physics: kPhysics,
                        slivers: [
                          SliverToBoxAdapter(
                            child: OosTypeWidget(
                                onChanged: (zone) {
                                  setState(() {
                                    currentZone = zone;
                                    SyncStatus status = SyncStatus.isNoSynced;
                                    if (zone.id ==
                                            oosEntity!.featureOosZoneId &&
                                        lastOosEntity!.values ==
                                            oosEntity!.values) {
                                      status = SyncStatus.synced;
                                    }
                                    oosEntity =
                                        oosEntity!.copyWith(status: status);
                                  });
                                },
                                currentZone: currentZone,
                                zones: widget.entity.feature.featureOosZones ??
                                    []),
                          ),
                          SliverSearchWidget<FeatureQuantity>(
                            data: featureOosProducts,
                            searchBy: (object) => object.item != null
                                ? object.item!.name! + (object.item!.code ?? '')
                                : object.product!.name! +
                                    (object.productPackaging!.barcode ?? ''),
                            onSearched: (newData) {
                              setState(() {
                                _featureOosProductsValid = newData;
                              });
                            },
                          ),
                          SliverPadding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              sliver: SliverList.builder(
                                itemCount: widget.entity.feature
                                        .featureOosProducts?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final featureQuantity =
                                      featureOosProducts[index];
                                  final oosValue = oosEntity!.values[index];
                                  if (!_featureOosProductsValid
                                      .contains(featureQuantity)) {
                                    return SizedBox.shrink();
                                  }
                                  return QuantityFieldItem(
                                    entity: featureQuantity,
                                    value: oosValue.value,
                                    onChanged: (value) {
                                      oosEntity = oosEntity!.copyWith(
                                          values: oosEntity!.values
                                              .replaceWhere(
                                                  (currentValue) =>
                                                      currentValue
                                                          .featureOosProductId ==
                                                      oosValue
                                                          .featureOosProductId,
                                                  OOSStatusValueEntity(
                                                      id: oosValue.id,
                                                      featureOosProductId: oosValue
                                                          .featureOosProductId,
                                                      value:
                                                          int.tryParse(value)))
                                              .toList(),
                                          status: SyncStatus.isNoSynced);
                                      setState(() {});
                                    },
                                    isLast:
                                        index == featureOosProducts.length - 1,
                                  );
                                },
                              ))
                        ],
                      );
                    }
                    if (state is FetchOosFailure) {
                      return Center(
                        child:
                            DataLoadErrorWidget(onPressed: () => fetchData()),
                      );
                    }
                    return Center(child: AppIndicator());
                  },
                ),
              ),
              ScheduleBuilder(
                feature: widget.entity.feature,
                builder: (callback) => FlatButton(
                  onPressed: isActive ? () => callback(saveData) : null,
                  name: 'Lưu',
                  color: AppColors.primary,
                  disableColor: AppColors.potPourri,
                  disableTextColor: AppColors.delRio,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
