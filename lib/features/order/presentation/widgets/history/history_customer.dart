import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constant/colors.dart';
import '../../../domain/entities/customer_identity.dart';

class HistoryCustomer extends StatelessWidget {
  final List<CustomerOrderHistory> customerOrderHistorys;
  const HistoryCustomer({super.key, required this.customerOrderHistorys});

  Map<dynamic, int> _exchangeTranform(List<ExchangeProceed> exchangeProceeds) {
    final Map<dynamic, int> _gifts = {};
    exchangeProceeds.forEachIndexed((index, element) {
      if (element.product != null) {
        _gifts[(
          element.product,
          element.productPackaging,
          element.hasPlayedGame
        )] = (_gifts[(
                  element.product,
                  element.productPackaging,
                  element.hasPlayedGame
                )] ??
                0) +
            element.quantity!;
      } else {
        _gifts[(element.item, element.hasPlayedGame)] =
            (_gifts[(element.item, element.hasPlayedGame)] ?? 0) +
                element.quantity!;
      }
    });
    return _gifts;
  }

  Map<Item, int> _prizeTranform(List<CustomerOrderPrizeHistory> prizes) {
    final Map<Item, int> _prizes = {};
    prizes.forEachIndexed((index, element) {
      _prizes[element.item] = (_prizes[element.item] ?? 0) + 1;
    });
    return _prizes;
  }

  String _itemInfo(dynamic item) {
    return switch (item) {
      (final Product product, final ProductPackaging productPackaging, _) =>
        ' ${productPackaging.unit?.name ?? ''} - ${product.name ?? ''}',
      (final Item gift, _) => ' ${gift.unitName ?? ''} - ${gift.name ?? ''}',
      Object() => '',
      null => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(24.h),
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.sqr)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Text('Lịch sử khách hàng',
                  style: context.textTheme.subtitle1),
            ),
            for (final history in customerOrderHistorys)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        (history.projectOutlet.name ?? '') +
                            ' - ' +
                            (history.projectBooth.name ?? '') +
                            ' (${DateTime.parse(history.dataTimestamp).toLocal().formatBy(DateFormat('dd/MM/yyyy hh:mm aaa', 'en'))})',
                        style: context.textTheme.body2?.copyWith(
                            color: '#252837'.toColor(),
                            fontWeight: FontWeight.w600)),
                    DefaultTextStyle(
                        style: context.textTheme.body2!
                            .copyWith(color: AppColors.black),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(builder: (context) {
                              final gifts = _exchangeTranform(history.exchanges
                                      .map((exchange) =>
                                          exchange.exchangeProceeds ?? [])
                                      .expand<ExchangeProceed>(
                                          (e) => e.toList())
                                      .toList())
                                  .entries;
                              if (gifts.isEmpty) return const SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quà tặng:',
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(color: AppColors.primary),
                                    ),
                                    for (final gift in gifts)
                                      RichText(
                                        text: TextSpan(
                                            text: 'x${gift.value}',
                                            style: context.textTheme.body2
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: '#252837'.toColor()),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${_itemInfo(gift.key)}',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                            ]),
                                      )
                                  ],
                                ),
                              );
                            }),
                            Builder(builder: (context) {
                              final prizes =
                                  _prizeTranform(history.prizes).entries;

                              if (prizes.isEmpty) return const SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quà Vòng quay may mắn:',
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(color: AppColors.primary),
                                    ),
                                    for (final item in prizes)
                                      RichText(
                                        text: TextSpan(
                                            text: 'x${item.value}',
                                            style: context.textTheme.body2
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: '#252837'.toColor()),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      ' ${item.key.unitName ?? ''} - ${item.key.name ?? ''}',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                            ]),
                                      )
                                  ],
                                ),
                              );
                            }),
                            Builder(builder: (context) {
                              if (history.samplings.isEmpty)
                                return const SizedBox();
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sampling:',
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(color: AppColors.primary),
                                    ),
                                    for (final sampling in history.samplings)
                                      RichText(
                                        text: TextSpan(
                                            text: 'x${sampling.quantity}',
                                            style: context.textTheme.body2
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: '#252837'.toColor()),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      ' ${sampling.unit?.name ?? ""}',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                              TextSpan(
                                                  text: ' - ',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                              TextSpan(
                                                  text:
                                                      ' ${sampling.product?.name ?? ""}',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                            ]),
                                      )
                                  ],
                                ),
                              );
                            }),
                          ],
                        ))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
