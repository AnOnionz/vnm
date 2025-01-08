import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/core/widgets/app_indicator.dart';
import 'package:vnm/core/widgets/button/flat.dart';
import 'package:vnm/core/widgets/data_load_error_widget.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/core/widgets/sliver_search_widget.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:vnm/features/schedule/presentation/widgets/schedule_builder.dart';

import '../../../../core/styles/theme.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../cubit/generic_data_cubit.dart';
import '../widgets/generic_data_item.dart';

class GenericDataPage extends StatefulWidget {
  final GeneralFeatureData entity;
  const GenericDataPage({super.key, required this.entity});

  @override
  State<GenericDataPage> createState() => _GenericDataPageState();
}

class _GenericDataPageState extends State<GenericDataPage> {
  final _formKey = GlobalKey<FormState>();
  final GenericDataCubit _cubit = Modular.get();
  late final featureNumerics = (widget.entity.feature.featureNumerics ?? [])
      .sorted((a, b) => a.ordinal! - b.ordinal!);
  late List<FeatureQuantity> _featureNumericsValid = featureNumerics;
  late final featureNumericAttributes =
      (widget.entity.feature.featureNumericAttributes ?? [])
          .sorted((a, b) => a.ordinal! - b.ordinal!);
  NumericSheetEntity? numericSheetEntity = null;

  bool get isActive =>
      numericSheetEntity?.status == SyncStatus.isNoSynced &&
      numericSheetEntity!.values.any((value) => value.value != null);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    _cubit.fetchData(feature: widget.entity.feature);
  }

  Future<void> onFetchSuccess(NumericSheetEntity? data) async {
    if (data != null) {
      numericSheetEntity = data;
    } else {
      final genericData = NumericSheetEntity(
          values: featureNumerics
              .map((featureNumeric) => featureNumericAttributes.map(
                    (numericAttribute) => NumericValueEntity(
                      featureNumericId: featureNumeric.id,
                      featureNumericAttributeId: numericAttribute.id,
                    ),
                  ))
              .expand((element) => element)
              .toList());
      numericSheetEntity = genericData;
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
        appBar: DefaultAppBar(title: widget.entity.feature.name ?? ''),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<GenericDataCubit, GenericDataState>(
                  bloc: _cubit,
                  listener: (context, state) {
                    if (state is GenericDataSuccess) {
                      onFetchSuccess(state.entity);
                    }
                    if (state is GenericDataFailure) {
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
                    if (state is GenericDataSuccess) {
                      return Form(
                        key: _formKey,
                        child: CustomScrollView(
                          physics: kPhysics,
                          slivers: [
                            SliverSearchWidget<FeatureQuantity>(
                              data: featureNumerics,
                              searchBy: (object) => object.item != null
                                  ? object.item!.name! +
                                      (object.item!.code ?? '')
                                  : object.product!.name! +
                                      (object.productPackaging!.barcode ?? ''),
                              onSearched: (newData) {
                                setState(() {
                                  _featureNumericsValid = newData;
                                });
                              },
                            ),
                            SliverPadding(
                                padding: EdgeInsets.only(bottom: 8.w),
                                sliver: SliverList.separated(
                                  itemCount: featureNumerics.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 8.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    final numericItem = featureNumerics[index];
                                    if (!_featureNumericsValid
                                        .contains(numericItem)) {
                                      return SizedBox.shrink();
                                    }
                                    return GenericDataItem(
                                      featureNumeric: numericItem,
                                      attributes: featureNumericAttributes,
                                      values: numericSheetEntity!.values
                                          .filter((element) =>
                                              element.featureNumericId ==
                                              numericItem.id)
                                          .toList(),
                                      onChanged: (newValue) {
                                        numericSheetEntity = numericSheetEntity!
                                            .copyWith(
                                                values: numericSheetEntity!
                                                    .values
                                                    .replaceWhere(
                                                        (currentValue) =>
                                                            currentValue ==
                                                            newValue,
                                                        newValue)
                                                    .toList(),
                                                status: SyncStatus.isNoSynced);
                                        setState(() {});
                                      },
                                    );
                                  },
                                ))
                          ],
                        ),
                      );
                    }
                    if (state is GenericDataFailure) {
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
                  onPressed: isActive
                      ? () => callback(() {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              _cubit.saveData(
                                  entity: numericSheetEntity!,
                                  feature: widget.entity.feature);
                            }
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
    );
  }
}
