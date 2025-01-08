import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/button/flat.dart';
import 'package:vnm/core/widgets/button/outline.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/home/home_module.dart';
import 'package:vnm/features/order/history_exchange_module.dart';
import 'package:vnm/features/order/order_module.dart';

class SuccessPage extends StatelessWidget {
  final GeneralFeatureData? generalFeature;
  final bool isUpdate;
  const SuccessPage({
    super.key,
    this.isUpdate = false,
    this.generalFeature,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: isUpdate
              ? Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(AppIcons.orderSuccess),
                    SizedBox(height: 40.h),
                    Text('ĐÃ LƯU THÀNH CÔNG', style: context.textTheme.h2),
                    SizedBox(height: 10.h),
                    Text('Tất cả chỉnh sửa đã được ghi nhận',
                        style: context.textTheme.body1
                            ?.copyWith(color: AppColors.nobel)),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                context.popUntil(HistoryExchangeModule.route);
                              },
                              name: 'OK',
                              color: AppColors.royalBlue),
                        ),
                      ],
                    ),
                    Spacer(flex: 3),
                  ],
                )
              : Column(
                  children: [
                    Spacer(),
                    SvgPicture.asset(AppIcons.orderSuccess),
                    SizedBox(height: 40.h),
                    Text('ĐỔI QUÀ THÀNH CÔNG', style: context.textTheme.h2),
                    SizedBox(height: 10.h),
                    Text('Cảm ơn quý khách đã mua hàng',
                        style: context.textTheme.body1
                            ?.copyWith(color: AppColors.nobel)),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlineButton(
                              onPressed: () {
                                context.popUntil(HomeModule.route);
                              },
                              name: 'Trang chủ',
                              color: AppColors.royalBlue),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: FlatButton(
                              onPressed: () {
                                context.popUntil(HomeModule.route);
                                context.nextRoute(OrderModule.route,
                                    arguments: generalFeature);
                              },
                              name: 'Tiếp tục ghi đơn',
                              color: AppColors.royalBlue),
                        ),
                      ],
                    ),
                    Spacer(flex: 3),
                  ],
                ),
        ),
      ),
    );
  }
}
