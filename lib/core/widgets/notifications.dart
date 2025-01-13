import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/widgets/popup.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';

import '../../features/home/presentation/widgets/require_task_notify.dart';
import '../../features/order/domain/entities/customer_identity.dart';
import '../constant/colors.dart';
import '../constant/enum.dart';
import '../utilities/overlay.dart';
import 'bottom_sheet_notification.dart';
import 'button/outline.dart';

void showRequiredAttendanceOut(VoidCallback onPressed) {
  showFailure(
    title: 'Chưa chấm công ra',
    icon: SvgPicture.asset(AppIcons.requiredTask),
    message: 'Chưa chấm công ra, bạn có chắc chắn muốn đăng xuất không ?',
    btnText: 'Đến trang chấm công',
    onPressed: onPressed,
  );
}

void showRequiredAttendanceIn(VoidCallback onPressed) {
  showFailure(
    title: 'Chưa chấm công vào',
    icon: SvgPicture.asset(AppIcons.requiredTask),
    message:
        'Chưa chấm công vào, yêu cầu chấm công trước khi vào ca làm việc ?',
    btnText: 'Đến trang chấm công',
    onPressed: onPressed,
  );
}

void showRequiredFeature(String feature, VoidCallback onPressed) {
  showWarning(
      title: 'Yêu cầu ${feature}',
      icon: SvgPicture.asset(AppIcons.requiredTask),
      btnText: 'Làm ngay',
      onPressed: onPressed);
}

void showRequiredSync(VoidCallback onPressed, String feature) {
  showFailure(
    title: 'Yêu cầu đồng bộ dữ liệu',
    icon: SvgPicture.asset(AppIcons.requiredTask),
    message:
        'Vẫn còn dữ liệu chưa được đồng bộ, yêu cầu đồng bộ tất cả dữ liệu trước khi $feature.',
    btnText: 'Đến trang đồng bộ',
    onPressed: onPressed,
  );
}

void showRequiredTaskBeforeLogout({required VoidCallback onPressed}) {
  showWarning(
      title: 'Chưa hoàn thành công việc',
      icon: SvgPicture.asset(AppIcons.requiredTask),
      btnText: 'Đăng xuất',
      onPressed: onPressed);
}

void showRequiredTask(
    {required List<FeatureEntity> features,
    required VoidCallback onPressed,
    FeatureEntity? feature}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(AppIcons.requiredTask),
          title: 'Chưa hoàn thành công việc',
          message: RequireTaskNotify(
            features: features,
            feature: feature,
          ),
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
                onPressed();
              },
              name: 'Về trang chủ',
              color: AppColors.primary)));
}

void showRequiredFaceVerified({required VoidCallback onPressed}) {
  showFailure(
    title: 'Chưa có hình ảnh trong Profile',
    icon: SvgPicture.asset(AppIcons.requiredProfileData),
    message:
        'Yêu cầu cập nhật hình ảnh trong Profile nhân viên để xác thực khi chấm công.',
    btnText: 'Đến Trang Profile Nhân viên',
    onPressed: onPressed,
  );
}

void showFaceNotFound({required VoidCallback onPressed}) {
  showFailure(
    title: 'Hình ảnh không hợp lệ',
    icon: SvgPicture.asset(AppIcons.profileError),
    message:
        'Không thể nhận diện gương mặt trong hình. Vui lòng chụp lại hình sao cho gương mặt bạn nằm trọn trong khung hình.',
    btnText: 'Thử lại',
    onPressed: onPressed,
  );
}

void showFaceNotMatch({required VoidCallback onPressed}) {
  showFailure(
    title: 'Gương mặt không khớp',
    icon: SvgPicture.asset(AppIcons.requiredProfileData),
    message:
        'Gương mặt trong hình không khớp với thông tin hồ sơ. Vui lòng chụp lại hình với đúng người cần xác nhận.',
    btnText: 'Thử lại',
    onPressed: onPressed,
  );
}

void showUploadFaceSuccess({
  required String title,
}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(AppIcons.profileSuccess),
          title: title,
          action: OutlineButton(
              onPressed: () => OverlayManager.hideDialog(),
              name: 'Ok',
              color: AppColors.royalBlue)));
}

void showUpdateProfilePending({required VoidCallback onPressed}) {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(AppIcons.pending),
          title: 'Gửi yêu cầu thành công',
          message: Text(
            'Yêu cầu điều chỉnh hồ sơ của bạn đã được gửi thành công và đang chờ duyệt.',
            textAlign: TextAlign.center,
            style: OverlayManager.currentContext!.textTheme.body1
                ?.copyWith(color: AppColors.nero),
          ),
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
                onPressed();
              },
              name: 'Về trang chủ',
              color: AppColors.royalBlue)));
}

void showRequiredProfileField() {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(AppIcons.requiredProfileData),
          title: 'Yêu cầu nhập đủ các trường bắt buộc',
          message: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Nhập tất cả các trường có dấu ',
                style: OverlayManager.currentContext!.textTheme.body1
                    ?.copyWith(color: AppColors.midnightExpress),
                children: [
                  TextSpan(
                    text: ' *',
                    style: OverlayManager.currentContext!.textTheme.body1
                        ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.normal),
                  ),
                ]),
          ),
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
              },
              name: 'Ok',
              color: AppColors.primary)));
}

void showTakeImageMultipleSource(
    {required VoidCallback onSource1, required VoidCallback onSource2}) {
  OverlayManager.showSheet(
      body: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.w),
        child: Text('Chụp trực tiếp hoặc upload từ thư viện',
            textAlign: TextAlign.center,
            style: OverlayManager.currentContext!.textTheme.h3
                ?.copyWith(color: AppColors.nightRider)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () async {
              OverlayManager.hideDialog();
              onSource1();
            },
            child: Column(
              children: [
                SvgPicture.asset(AppIcons.sourceCamera),
                Text('Camera',
                    style: OverlayManager.currentContext!.textTheme.body1
                        ?.copyWith(color: AppColors.nightRider))
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              OverlayManager.hideDialog();
              onSource2();
            },
            child: Column(
              children: [
                SvgPicture.asset(AppIcons.image),
                Text('Upload',
                    style: OverlayManager.currentContext!.textTheme.body1
                        ?.copyWith(color: AppColors.nightRider))
              ],
            ),
          )
        ]),
      )
    ],
  ));
}

void showRemainingQuotas(
    {required RemainingQuota remainingQuota, VoidCallback? onPressed}) {
  ;

  final body = switch (remainingQuota.type!) {
    QuotaType.order => (
        icon: AppIcons.failure,
        title: 'Đạt giới hạn đơn hàng',
        message: 'Khách đã đạt đến giới hạn số lượng đơn hàng có thể tạo',
        remainingQuantity: null,
        type: null,
        btnText: 'Ok'
      ),
    QuotaType.exchange => (
        icon: AppIcons.remainingExchange,
        title: 'Số lượng quà còn lại',
        message: 'Số phần quà tối đa khách có thể nhận là',
        remainingQuantity: math.max(remainingQuota.remainingQuantity ?? 0, 0),
        type: 'quà',
        btnText: 'Tiếp tục ghi đơn'
      ),
    QuotaType.purchase => (
        icon: AppIcons.failure,
        title: '',
        message: '',
        remainingQuantity: null,
        type: null,
        btnText: 'Ok'
      ),
  };

  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(body.icon),
          title: body.title,
          message: Builder(builder: (context) {
            return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: body.message,
                    style: context.textTheme.body1
                        ?.copyWith(color: AppColors.nero),
                    children: body.remainingQuantity != null
                        ? [
                            TextSpan(
                              text: ' ${body.remainingQuantity} ',
                              style: context.textTheme.body2
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            TextSpan(
                              text: '${body.type}',
                              style: context.textTheme.body1
                                  ?.copyWith(color: AppColors.nero),
                            )
                          ]
                        : []));
          }),
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
                onPressed?.call();
              },
              name: body.btnText,
              color: AppColors.primary)));
}

void showOosAbout() {
  OverlayManager.showSheet(
      body: BottomSheetNotification(
          icon: SvgPicture.asset(AppIcons.requiredTask),
          title: 'Hướng dẫn nhập tồn',
          message: Builder(builder: (context) {
            return DefaultTextStyle(
              style: context.textTheme.body1!.copyWith(color: AppColors.nobel),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('1. Nhân viên nhập liệu trước 9:30',
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: '201A25'.toColor())),
                    Text(
                        '•  Sau thời gian quy định, chức năng nhập liệu sẽ bị đóng'),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text('2. Tick chọn chính xác vị trí nhập tồn:',
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: '201A25'.toColor())),
                    Text('•  Nhập tồn ở line, ụ, kệ'),
                    Text('•  Hay nhập tồn ở cả line, ụ, kệ và kho'),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text('3. Nhập số liệu:',
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: '201A25'.toColor())),
                    Text('•  Sản phẩm hết thì nhập 0, không được bỏ trống'),
                  ],
                ),
              ),
            );
          }),
          action: OutlineButton(
              onPressed: () {
                OverlayManager.hideDialog();
              },
              name: 'Ok',
              color: AppColors.primary)));
}

void showSchedule() {
  showFailure(
      title: 'Ngoài thời gian hoạt động',
      message:
          'Chức năng đang nằm ngoài thời gian hoạt động. Vui lòng thử lại sau',
      btnText: 'Ok');
}

void showLuckyWheelCancel({required VoidCallback onPressed}) {
  showWarning(
      title: 'Thoát',
      icon: SizedBox.shrink(),
      message:
          'Nếu “Xác nhận” thoát, bạn sẽ không thể tiếp tục vòng quay may mắn.',
      onPressed: onPressed,
      btnText: 'Xác nhận');
}
