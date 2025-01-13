import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:fms/features/images/presentation/widgets/image_thumbnail_widget.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/images.dart';
import 'generic_input.dart';

class GenericDataItem extends StatelessWidget {
  final FeatureQuantity featureNumeric;
  final List<FeatureNumericAttribute> attributes;
  final List<NumericValueEntity> values;
  final void Function(NumericValueEntity newValue) onChanged;
  GenericDataItem(
      {super.key,
      required this.featureNumeric,
      required this.attributes,
      required this.values,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16.sqr)),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                    height: 65.w,
                    width: 65.w,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.roseWhite.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.sqr)),
                        ),
                        Align(
                          child: (featureNumeric.item?.imageUrl ?? '')
                                      .isEmpty &&
                                  (featureNumeric.product?.imageUrl ?? '')
                                      .isEmpty
                              ? Image.asset(AppImages.product)
                              : ImageThumbnailWidget(
                                  height: 65.w,
                                  width: 65.w,
                                  imageUrl: featureNumeric.item != null
                                      ? featureNumeric.item!.imageUrl
                                      : featureNumeric.product!.imageUrl!,
                                  thumbnailUrl: featureNumeric.item != null
                                      ? featureNumeric.item!.thumbnailUrl
                                      : featureNumeric.product!.thumbnailUrl!,
                                ),
                        ),
                      ],
                    )),
                SizedBox(
                  width: 18.h,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (featureNumeric.item != null)
                        Text(
                          featureNumeric.item!.name!,
                          style: context.textTheme.caption1,
                        ),
                      if (featureNumeric.product != null)
                        Text(
                          featureNumeric.product!.name!,
                          style: context.textTheme.caption1,
                        ),
                      if (featureNumeric.item != null)
                        Text(
                          featureNumeric.item!.code!,
                          style: context.textTheme.caption2
                              ?.copyWith(color: AppColors.nobel),
                        ),
                      if (featureNumeric.productPackaging != null)
                        Text(
                          featureNumeric.productPackaging!.barcode!,
                          style: context.textTheme.caption2
                              ?.copyWith(color: AppColors.nobel),
                        ),
                      Text(
                        'Loại: ${featureNumeric.item != null ? featureNumeric.item!.itemTypeName! : 'sản phẩm'}',
                        style: context.textTheme.caption2
                            ?.copyWith(color: AppColors.nobel),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...attributes.map((attribute) {
            final valueAttribute = values.firstWhereOrNull(
                (element) => element.featureNumericAttributeId == attribute.id);
            if (valueAttribute == null) return SizedBox.shrink();
            return GenericInput(
              label: attribute.name ?? 'Tên sản phẩm',
              type: attribute.type ?? GenericType.integer,
              initValue: valueAttribute.value,
              minValue: attribute.minimum!.toNum() ?? 0,
              maxValue: attribute.maximum!.toNum() ?? 0,
              validator: (value) {
                if (valueAttribute.checkInvalid(
                        featureNumericAttribute: attribute) ==
                    true) {
                  return 'dữ liệu không hợp lệ';
                }
                return null;
              },
              onChanged: (value) {
                onChanged(valueAttribute.copyWith(value: value));
              },
            );
          }).toList()
        ],
      ),
    );
  }
}
