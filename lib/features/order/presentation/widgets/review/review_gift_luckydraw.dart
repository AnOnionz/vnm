import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:vnm/features/order/presentation/widgets/review/review_container.dart';

import '../../../../../core/constant/colors.dart';

class ReviewGiftLuckyDraw extends StatefulWidget {
  final String title;
  final List<CustomerLuckyDraw> customerLuckyDraws;

  const ReviewGiftLuckyDraw(
      {super.key, required this.title, required this.customerLuckyDraws});

  @override
  State<ReviewGiftLuckyDraw> createState() => _ReviewGiftLuckyDrawState();
}

class _ReviewGiftLuckyDrawState extends State<ReviewGiftLuckyDraw> {
  final Map<Item, int> _gifts = {};
  late int total;

  @override
  void didChangeDependencies() {
    _handleGifts();
    super.didChangeDependencies();
  }

  void _handleGifts() {
    late final giftProceeds = widget.customerLuckyDraws
        .map(
          (e) => e.prizeItems,
        )
        .expand((element) => element)
        .toList();
    widget.customerLuckyDraws.forEachIndexed((index, gift) {
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
    total = _gifts.entries
        .fold(0, (previousValue, element) => previousValue + element.value);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ReviewContainer(
        margin: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: context.textTheme.subtitle1,
            ),
            SizedBox(
              height: 14.h,
            ),
            for (final gift in _gifts.entries)
              _GiftInfoItem(gift: gift.key, quantity: gift.value),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text(
                  'Tổng số lượng',
                  style: context.textTheme.button2
                      ?.copyWith(color: AppColors.primary),
                )),
                Flexible(
                    child: Text(total > 0 ? 'x${total}' : '$total',
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: AppColors.primary)))
              ],
            )
          ],
        ));
  }
}

class _GiftInfoItem extends StatelessWidget {
  final Item gift;
  final int quantity;
  const _GiftInfoItem({required this.gift, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(gift.name ?? '',
                style:
                    context.textTheme.body1?.copyWith(color: AppColors.black)),
          ),
          Flexible(
              child: Text(
            'x${quantity}',
            style: context.textTheme.body1,
          )),
        ],
      ),
    );
  }
}
