import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/icons.dart';
// ignore: unused_import
import 'package:vnm/core/mixins/common.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/services/connectivity/connectivity_service.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/order/domain/entities/order_entity.dart';
import 'package:vnm/features/order/history_exchange_module.dart';
import 'package:vnm/features/order/presentation/cubit/delete_order_cubit.dart';
import 'package:vnm/features/order/presentation/cubit/lucky_draw_cubit.dart';

import '../../../../core/utilities/overlay.dart';
import '../../../../core/widgets/popup.dart';
import '../../../general/presentation/page/mixin_general.dart';
import '../cubit/get_order_cubit.dart';
import '../widgets/exchange_detail.dart';

class HistoryExchangeDetailPage extends StatefulWidget {
  final OrderEntity order;
  final FeatureEntity feature;

  const HistoryExchangeDetailPage({
    super.key,
    required this.order,
    required this.feature,
  });

  @override
  State<HistoryExchangeDetailPage> createState() =>
      _HistoryExchangeDetailPageState();
}

class _HistoryExchangeDetailPageState extends State<HistoryExchangeDetailPage>
    with GeneralDataMixin {
  late OrderEntity _order = widget.order;
  final _network = Modular.get<ConnectivityService>();
  final deteleOrderCubit = Modular.get<DeleteOrderCubit>();
  final getOrderCubit = Modular.get<GetOrderCubit>();
  final luckyDrawCubit = Modular.get<LuckyDrawCubit>();

  @override
  void initState() {
    super.initState();
    _fetchLuckyDraws();
    _deleteOrderListener();
    _editOrderListener();
  }

  void _fetchLuckyDraws() {
    if (general?.attendance?.id != null && _order.id != null) {
      luckyDrawCubit.getLuckyDrawInfo(general!.attendance!.id!, _order.id!);
    }
  }

  void _deleteOrder({required LuckyDrawState luckyDrawState}) {
    final hasLuckyDraw = luckyDrawState is LuckyDrawSuccessed
        ? luckyDrawState.data.customerLuckyDraws.isNotEmpty &&
            luckyDrawState.data.customerLuckyDraws
                .any((element) => element.prizeResults.isNotEmpty)
        : true;
    if (hasLuckyDraw == true) {
      showFailure(
        title: 'Không thể xoá',
        icon: SvgPicture.asset(AppIcons.failure),
        message: luckyDrawState is LuckyDrawSuccessed
            ? 'Đơn hàng đã có quà lucky draw nên không được xóa'
            : 'Bạn không thể xóa đơn hàng này, vui lòng thử lại sau.',
        btnText: 'Ok',
      );
      return;
    }
    showWarning(
        title: 'Bạn có chắc muốn xoá đơn này không ?',
        icon: SvgPicture.asset(AppIcons.binCircle),
        btnText: 'Xóa',
        onPressed: () {
          deteleOrderCubit.deleteOrder(order: _order, feature: widget.feature);
        });
  }

  void _deleteOrderListener() {
    deteleOrderCubit.stream.listen((state) {
      if (state is DeleteOrderSuccess) {
        context.pop();
        OverlayManager.showSimpleToast(
            content: Center(
                child: Text(
              'Xóa đơn hàng thành công',
              style: context.textTheme.body2,
            )),
            background: 'EAF6F0'.toColor(),
            context: context);
      }
      if (state is DeleteOrderFailure) {
        showFailure(
            title: 'Xóa đơn hàng thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình xóa đơn hàng',
            btnText: 'Thử lại',
            onPressed: () {
              deteleOrderCubit.deleteOrder(
                  order: _order, feature: widget.feature);
            });
      }
    });
  }

  Future<void> _editOrder() async {
    getOrderCubit.getOrderById(orderId: _order.id!, feature: widget.feature);
  }

  void _editOrderListener() {
    getOrderCubit.stream.listen((state) async {
      if (state is GetOrderSuccess) {
        if (state.order == null) {
          showFailure(
              title: 'Không tìm thấy đơn hàng',
              icon: SvgPicture.asset(AppIcons.failure),
              message: 'Không tìm thấy đơn hàng này, vui lòng thử lại',
              btnText: 'Thử lại',
              onPressed: () {
                getOrderCubit.getOrderById(
                    orderId: _order.id!, feature: widget.feature);
              });
          return;
        }

        await context.nextRoute(HistoryExchangeModule.edit, arguments: [
          GeneralFeatureData(general: general!, feature: widget.feature),
          state.order
        ]);
      }
      if (state is GetOrderFailure) {
        showFailure(
            title: 'Không tìm thấy đơn hàng',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình tìm kiếm đơn hàng',
            btnText: 'Thử lại',
            onPressed: () {
              getOrderCubit.getOrderById(
                  orderId: _order.id!, feature: widget.feature);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LuckyDrawCubit, LuckyDrawState>(
      bloc: luckyDrawCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBar(
            onBack: () => context.pop(),
            title:
                'Lịch sử ${(widget.feature.name ?? "ghi nhận đơn hàng").toLowerCase()}',
            action: PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    if (!_network.hasConnected) {
                      showInternetFailure();
                      return;
                    }
                    await _editOrder();
                    break;
                  case 'delete':
                    _deleteOrder(luckyDrawState: state);
                    break;
                }
              },
              color: AppColors.white,
              position: PopupMenuPosition.under,
              surfaceTintColor: AppColors.white,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (_order.status == SyncStatus.synced)
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(
                      'Chỉnh đơn',
                      textAlign: TextAlign.left,
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(
                    'Xóa đơn',
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
              child: Container(
                padding: EdgeInsets.all(8.w),
                margin: EdgeInsets.only(right: 16.w),
                child:
                    SvgPicture.asset(AppIcons.dots, width: 24.h, height: 24.h),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 30.h),
            child: ExchangeDetail(
              order: _order,
              feature: widget.feature,
              customerLuckyDraws: state is LuckyDrawSuccessed
                  ? state.data.customerLuckyDraws
                  : [],
              isHistory: true,
            ),
          ),
        );
      },
    );
  }
}
