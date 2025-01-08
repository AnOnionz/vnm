import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/styles/theme.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/presentation/widgets/data_feature_widget.dart';
import 'package:vnm/features/order/presentation/widgets/sampling/sampling_container.dart';

import '../../../../core/constant/colors.dart';
import '../../../general/domain/entities/config_entity.dart';
import '../widgets/bottom_buttons.dart';
import '../widgets/input_quantity.dart';

class OrderSamplingPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final void Function(List<OrderSamplingEntity> samplings) onSaveData;
  const OrderSamplingPage(
      {super.key,
      required this.onNext,
      required this.onBack,
      required this.onSaveData});

  @override
  State<OrderSamplingPage> createState() => _OrderSamplingPageState();
}

class _OrderSamplingPageState extends State<OrderSamplingPage> {
  late final dataFeature = DataFeature.of(context);
  late final featureSamplings =
      (dataFeature.data.feature.featureSamplings ?? [])
          .sorted((a, b) => a.ordinal! - b.ordinal!);
  late final List<OrderSamplingEntity> _samplings =
      dataFeature.order.samplings ?? [];
  late final Map<FeatureSampling, OrderSamplingEntity> _items = {};

  bool get validate => _items.entries.any((field) {
        return (field.value.quantity ?? 0) > 0;
      });

  @override
  void didChangeDependencies() {
    featureSamplings.forEach((featureSampling) {
      final sampling = _samplings.firstWhereOrNull(
          (element) => element.featureSamplingId == featureSampling.id);

      _items[featureSampling] = OrderSamplingEntity(
          id: sampling?.id,
          quantity: sampling?.quantity,
          featureSamplingId: featureSampling.id,
          product: featureSampling.product,
          unit: featureSampling.unit,
          productPackaging: featureSampling.productPackaging);
    });
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.sqr),
                      topRight: Radius.circular(10.sqr))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Text(
                      'Sampling',
                      style: context.textTheme.subtitle1,
                    ),
                  ),
                  Expanded(
                      child: CustomScrollView(
                    physics: kPhysics,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        sliver: SliverList.separated(
                          itemCount: _items.length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.whisper,
                          ),
                          itemBuilder: (context, index) {
                            final samplingProduct =
                                _items.keys.elementAt(index);
                            final sampling = _items.values.elementAt(index);

                            return SamplingContainer(
                              leading: Text(samplingProduct.product!.name!,
                                  style: context.textTheme.body1),
                              unit: Text(samplingProduct.unit!.name!,
                                  style: context.textTheme.subtitle1),
                              trailing: InputQuantity(
                                value: sampling.quantity ?? 0,
                                max: 10000,
                                onIncreased: (value) {
                                  setState(() {
                                    _items.values.elementAt(index).quantity =
                                        value;
                                  });
                                },
                                onDecreased: (value) {
                                  setState(() {
                                    _items.values.elementAt(index).quantity =
                                        value;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )),
                ],
              ),
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
                  onBack: widget.onBack,
                  onNext: () {
                    widget.onSaveData(_items.entries
                        .map((e) => e.value)
                        .where((element) => (element.quantity ?? 0) > 0)
                        .toList());
                    widget.onNext();
                  },
                ),
              ),
            )
          ],
        ));
  }
}
