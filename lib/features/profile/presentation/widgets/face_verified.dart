import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/services/media/media_service.dart';
import 'package:vnm/core/widgets/popup.dart';
import 'package:vnm/features/profile/mixin_user.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/widgets/notifications.dart';
import '../cubit/upload_face_cubit.dart';

class FaceVerifiedWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  const FaceVerifiedWidget({super.key, required this.onSuccess});

  @override
  State<FaceVerifiedWidget> createState() => _FaceVerifiedWidgetState();
}

class _FaceVerifiedWidgetState extends State<FaceVerifiedWidget>
    with UserMixin {
  final _cubit = Modular.get<UploadFaceCubit>();

  StreamSubscription<UploadFaceState>? _subscription;
  final _mediaService = MediaService();
  XFile? image;

  Future<void> verifyImage() async {
    final file = await _mediaService.pickImage();

    if (file != null) {
      final hasFace = await _mediaService.faceDetector(file);
      if (!hasFace) {
        showFaceNotFound(onPressed: verifyImage);
        return;
      }
      setState(() {
        image = file;
      });
      _cubit.upload(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    _subscription = _cubit.stream.listen((state) {
      if (state is UploadFaceSuccess) {
        showUploadFaceSuccess(
          title: 'Cập nhật thành công',
        );
        widget.onSuccess();
      }
      if (state is UploadFaceFailure) {
        if (state.failure is SocketFailure) {
          showInternetFailure();
          return;
        }
        showFailure(
            title: 'Cập nhật thất bại',
            icon: SvgPicture.asset(AppIcons.failure),
            message: state.failure.message ??
                'Phát sinh lỗi trong quá trình cập nhật',
            btnText: 'Thử lại',
            onPressed: verifyImage);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(user!.isFaceVerified ?? true)) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.h, left: 16.w, right: 16.w),
        padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 33.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.sqr),
            color: AppColors.white),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text:
                    'Tài khoản chưa được cập nhật hình ảnh xác thực gương mặt ',
                style:
                    context.textTheme.body1?.copyWith(color: AppColors.black),
                children: [
                  TextSpan(
                    text: 'cập nhật ngay',
                    style: context.textTheme.body1?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = verifyImage,
                  )
                ])),
      );
    }
    return SizedBox();
  }
}
