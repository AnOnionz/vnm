import 'package:flutter/cupertino.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/order/domain/entities/customer_info_with_luckydraw_entity.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/presentation/widgets/review/review_gift_luckydraw.dart';

import '../../../../core/styles/theme.dart';
import 'review/review_customer.dart';
import 'review/review_gift.dart';
import 'review/review_image.dart';
import 'review/review_product.dart';
import 'review/review_sampling.dart';

class ExchangeDetail extends StatelessWidget {
  final FeatureEntity feature;
  final OrderEntity order;
  final bool isHistory;
  final List<CustomerLuckyDraw> customerLuckyDraws;
  const ExchangeDetail(
      {super.key,
      required this.order,
      required this.feature,
      this.isHistory = false,
      this.customerLuckyDraws = const []});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: kPhysics,
      slivers: [
        if (feature.featureOrder!.hasCustomer ?? true)
          SliverToBoxAdapter(
            child: ReviewCustomer(
                featureCustomers: feature.featureCustomers ?? [],
                customerInfos: order.customerInfos,
                createdDate: isHistory ? order.dataTimestamp : null),
          ),
        if (feature.featureOrder!.hasPurchase ?? true)
          SliverToBoxAdapter(
            child: ReviewProduct(
              products: feature.featureOrder!.products ?? [],
              purchases: order.purchases,
            ),
          ),
        if (feature.featureOrder!.hasExchange ?? true)
          SliverToBoxAdapter(
            child: ReviewGift(
              title: 'Quà tặng',
              schemes: feature.featureSchemes ?? <FeatureScheme>[],
              exchanges: (order.exchanges ?? [])
                  .where(
                    (element) => element.id != -1,
                  )
                  .toList(),
            ),
          ),
        if (customerLuckyDraws
            .any((element) => element.prizeResults.isNotEmpty))
          SliverToBoxAdapter(
            child: ReviewGiftLuckyDraw(
                title: 'Quà tặng vòng quay may mắn',
                customerLuckyDraws: customerLuckyDraws),
          ),
        if (feature.featureOrder!.hasExchange ?? true)
          SliverToBoxAdapter(
            child: ReviewGift(
              title: 'Quà tặng game',
              isPlayedGame: true,
              schemes: feature.featureSchemes ?? <FeatureScheme>[],
              exchanges: order.exchanges ?? [],
            ),
          ),
        if (feature.featureOrder!.hasSampling ?? true)
          SliverToBoxAdapter(
            child: ReviewSampling(
              featureSamplings: feature.featureSamplings ?? [],
              samplings: order.samplings,
            ),
          ),
        if (feature.featureOrder!.hasPhoto ?? true)
          SliverToBoxAdapter(
            child: ReviewImage(
                enableShare: isHistory,
                featurePhotos: feature.featurePhotos ?? [],
                photos: order.photos ?? order.localPhotos.toList()),
          ),
        SliverToBoxAdapter(
          child: const SizedBox(height: 8),
        ),
      ],
    );
  }
}
