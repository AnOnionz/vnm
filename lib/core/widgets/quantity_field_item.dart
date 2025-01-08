import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/matter_container.dart';
import 'package:vnm/features/images/presentation/widgets/image_view.dart';

import '../../features/general/domain/entities/config_entity.dart';
import '../constant/colors.dart';
import '../constant/images.dart';
import 'advanced_text_field.dart';

class QuantityFieldItem extends StatefulWidget {
  final FeatureQuantity entity;
  final int? value;
  final void Function(String value) onChanged;
  final bool isLast;
  final String? unit;
  QuantityFieldItem(
      {super.key,
      required this.entity,
      required this.value,
      this.isLast = false,
      required this.onChanged,
      this.unit});

  @override
  State<QuantityFieldItem> createState() => _QuantityFieldItemState();
}

class _QuantityFieldItemState extends State<QuantityFieldItem> {
  bool get isItem => widget.entity.item != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
      padding: EdgeInsets.all(15.h),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16.sqr)),
      child: MatterContainer(
          leading: (widget.entity.item?.thumbnailUrl ?? '').isEmpty &&
                  (widget.entity.product?.thumbnailUrl ?? '').isEmpty
              ? Image.asset(AppImages.product)
              : ImageThumbnailWidget(
                  height: 65.w,
                  width: 65.w,
                  imageUrl: isItem
                      ? widget.entity.item!.imageUrl
                      : widget.entity.product!.imageUrl!,
                  thumbnailUrl: isItem
                      ? widget.entity.item!.thumbnailUrl
                      : widget.entity.product!.thumbnailUrl!,
                ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isItem
                    ? widget.entity.item!.name!
                    : widget.entity.product!.name!,
                style: context.textTheme.caption1,
              ),
              Text(
                isItem
                    ? widget.entity.item!.code!
                    : widget.entity.productPackaging!.barcode!,
                style: context.textTheme.caption2
                    ?.copyWith(color: AppColors.nobel),
              ),
              Text(
                'Loại: ${isItem ? widget.entity.item!.itemTypeName! : 'sản phẩm'}',
                style: context.textTheme.caption2
                    ?.copyWith(color: AppColors.nobel),
              )
            ],
          ),
          trailing: AdvancedTextField(
            value: widget.value != null ? widget.value.toString() : null,
            onChanged: widget.onChanged,
            textInputAction:
                widget.isLast ? TextInputAction.done : TextInputAction.next,
            unit: widget.unit ??
                ((isItem
                        ? widget.entity.item?.unitName
                        : widget.entity.productPackaging?.unitName) ??
                    'đơn vị'),
          )),
    );
  }
}
