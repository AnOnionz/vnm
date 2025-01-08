import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/widgets/button/flat.dart';
import 'package:vnm/features/home/home_module.dart';

import '../constant/colors.dart';
import '../constant/enum.dart';
import '../constant/icons.dart';
import '../utilities/overlay.dart';
import 'bottom_sheet_notification.dart';
import 'button/outline.dart';

void showSuccess(
    {required String title, Widget? icon, VoidCallback? onPressed}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: icon ?? SvgPicture.asset(AppIcons.success),
          title: title,
          action: OutlineButton(
              onPressed: onPressed ??
                  () => Modular.to
                      .popUntil(ModalRoute.withName(HomeModule.route)),
              name: 'Về trang chủ',
              color: AppColors.royalBlue)));
}

void showFailure({
  required String title,
  Widget? icon,
  String? message,
  required String btnText,
  VoidCallback? onPressed,
}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: icon ?? SvgPicture.asset(AppIcons.failure),
          title: title,
          message: message != null
              ? Builder(builder: (context) {
                  return Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.textTheme.body1
                        ?.copyWith(color: AppColors.nero),
                  );
                })
              : null,
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
                onPressed?.call();
              },
              name: btnText,
              color: AppColors.primary)));
}

void showWarning({
  required String title,
  required Widget icon,
  String? message,
  required String btnText,
  required VoidCallback onPressed,
}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: icon,
          title: title,
          message: message != null
              ? Builder(builder: (context) {
                  return Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.textTheme.body1
                        ?.copyWith(color: AppColors.nero),
                  );
                })
              : null,
          action: FlatButton(
              onPressed: () {
                OverlayManager.hideDialog();
                onPressed();
              },
              name: btnText,
              color: AppColors.primary)));
}

void showInternetFailure([VoidCallback? onPressed]) {
  showFailure(
      title: 'Không có kết nối mạng',
      icon: SvgPicture.asset(AppIcons.requiredInternet),
      message: 'Kết nối mạng không ổn định, vui lòng kiểm tra lại kết nối mạng',
      btnText: 'OK',
      onPressed: onPressed);
}

void showUrgencyTurnOn() {
  OverlayManager.showDefaultToast(
    key: 'urgency',
    msg: 'Vui lòng kết thúc khi bạn quay lại vị trí',
    title: 'Báo cáo khẩn đang bật',
    icon: SvgPicture.asset(
      AppIcons.ring,
    ),
    duration: 1.days,
    isDismissable: false,
    gravity: ToastGravity.top,
    isDraggable: true,
  );
}
