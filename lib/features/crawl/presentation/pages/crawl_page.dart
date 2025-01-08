import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/button/flat.dart';
import 'package:vnm/core/widgets/quantity_field_item.dart';
import 'package:vnm/core/widgets/sliver_search_widget.dart';
import 'package:vnm/features/crawl/domain/entities/crawl_quantity_entity.dart';
import 'package:vnm/features/crawl/presentation/cubit/crawl_cubit.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/icons.dart';
import '../../../../core/services/network_time/network_time_service.dart';
import '../../../../core/styles/theme.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_indicator.dart';
import '../../../../core/widgets/data_load_error_widget.dart';
import '../../../../core/widgets/popup.dart';

class CrawlPage extends StatefulWidget {
  final GeneralFeatureData entity;
  const CrawlPage({super.key, required this.entity});

  @override
  State<CrawlPage> createState() => _CrawlPageState();
}

class _CrawlPageState extends State<CrawlPage> {
  final networkTimeService = Modular.get<NetworkTimeService>();
  final CrawlCubit _cubit = Modular.get();
  late final featureQuantities = (widget.entity.feature.featureQuantities ?? [])
      .sorted((a, b) => a.ordinal! - b.ordinal!);
  late List<FeatureQuantity> _featureQuantitiesValid = featureQuantities;
  CrawlQuantityEntity? crawlQuantityEntity = null;

  bool get isActive =>
      crawlQuantityEntity?.status == SyncStatus.isNoSynced &&
      crawlQuantityEntity!.values.any((value) => value.value != null);

  Completer<bool> _completer = Completer();

  @override
  void initState() {
    super.initState();
    fetchQuantities();
  }

  void fetchQuantities() {
    _cubit.fetchData(
        general: widget.entity.general, feature: widget.entity.feature);
  }

  Future<void> onFetchSuccess(CrawlQuantityEntity? data) async {
    if (data != null) {
      crawlQuantityEntity = data;
    } else {
      final timestamp = await networkTimeService.ntpDateTime();
      final crawlQuantities = CrawlQuantityEntity(
          dataUuid: Uuid().v1(),
          dataTimestamp: timestamp,
          values: featureQuantities
              .map((featureQuantity) => CrawlQuantitylValueEntity(
                  featureQuantityId: featureQuantity.id))
              .toList());
      crawlQuantityEntity = crawlQuantities;
    }
    setState(() {});

    if (!_completer.isCompleted) _completer.complete(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.entity.feature.name!,
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocConsumer<CrawlCubit, CrawlState>(
                    bloc: _cubit,
                    listener: (context, state) {
                      if (state is CrawlSuccess) {
                        onFetchSuccess(state.quantityEntity);
                      }
                      if (state is CrawlFailure) {
                        showFailure(
                          title: 'Tải dữ liệu thất bại',
                          icon: SvgPicture.asset(AppIcons.failure),
                          message: state.failure.message,
                          btnText: 'Thử lại',
                          onPressed: () async {
                            await Future.delayed(
                              300.milliseconds,
                              () => fetchQuantities(),
                            );
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CrawlSuccess && _completer.isCompleted) {
                        return CustomScrollView(
                          physics: kPhysics,
                          slivers: [
                            SliverSearchWidget<FeatureQuantity>(
                              data: featureQuantities,
                              searchBy: (object) => object.item != null
                                  ? object.item!.name! +
                                      (object.item!.code ?? '')
                                  : object.product!.name! +
                                      (object.productPackaging!.barcode ?? ''),
                              onSearched: (newData) {
                                setState(() {
                                  _featureQuantitiesValid = newData;
                                });
                              },
                            ),
                            SliverPadding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                sliver: SliverList.builder(
                                  itemCount: featureQuantities.length,
                                  itemBuilder: (context, index) {
                                    final featureQuantity =
                                        featureQuantities[index];
                                    final quantity = crawlQuantityEntity!.values
                                        .where((e) =>
                                            e.featureQuantityId ==
                                            featureQuantity.id)
                                        .first;

                                    if (!_featureQuantitiesValid
                                        .contains(featureQuantity)) {
                                      return SizedBox.shrink();
                                    }
                                    return QuantityFieldItem(
                                      entity: featureQuantity,
                                      value: quantity.value,
                                      onChanged: (value) {
                                        setState(() {
                                          quantity.value = int.tryParse(value);
                                          crawlQuantityEntity =
                                              crawlQuantityEntity!.copyWith(
                                                  status:
                                                      SyncStatus.isNoSynced);
                                        });
                                      },
                                      isLast:
                                          index == featureQuantities.length - 1,
                                      unit: (widget.entity.feature.name ?? '')
                                              .toLowerCase()
                                              .contains('giá')
                                          ? 'VNĐ'
                                          : null,
                                    );
                                  },
                                ))
                          ],
                        );
                      }
                      if (state is CrawlFailure) {
                        return Center(
                          child: DataLoadErrorWidget(
                              onPressed: () => fetchQuantities()),
                        );
                      }
                      return Center(child: AppIndicator());
                    },
                  ),
                ),
                ScheduleBuilder(
                  feature: widget.entity.feature,
                  builder: (callback) => FlatButton(
                    onPressed: isActive
                        ? () => callback(() {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _cubit.saveData(
                                  entity: crawlQuantityEntity!,
                                  feature: widget.entity.feature);
                            })
                        : null,
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
      ),
    );
  }
}
