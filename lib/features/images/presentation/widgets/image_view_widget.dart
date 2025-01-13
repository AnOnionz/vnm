import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/cache_image_network/cached_image.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';

import 'package:fms/core/widgets/app_indicator.dart';
import 'package:fms/core/widgets/popup.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/icons.dart';

class ImageViewWidget extends StatefulWidget {
  final String? url;
  final String? path;
  final VoidCallback? onDeleted;
  const ImageViewWidget({super.key, this.path, this.url, this.onDeleted})
      : assert(url != null || path != null);

  @override
  State<ImageViewWidget> createState() => _ImageViewWidgetState();
}

class _ImageViewWidgetState extends State<ImageViewWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.sqr),
          side: BorderSide(width: 3, color: AppColors.white)),
      contentPadding: EdgeInsets.all(4.h),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      children: <Widget>[
        Stack(
          children: [
            (widget.path != null)
                ? Align(
                    child: Builder(builder: (context) {
                      final file = Image.file(File(widget.path!));
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(6.sqr),
                        child: Container(
                          width: file.width,
                          height: file.height,
                          child: FittedBox(fit: BoxFit.fill, child: file),
                        ),
                      );
                    }),
                  )
                : Align(
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.sqr),
                    child: CachedImage(
                      placeholder: (p0, p1) => SizedBox(
                        height: 300.h,
                        width: context.screenWidth - 32.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIndicator(),
                          ],
                        ),
                      ),
                      errorWidget: (p0, p1, p2) => Icon(Icons.error),
                      imageUrl: widget.url!,
                    ),
                  )),
            Positioned(
              right: 10.h,
              top: 10.h,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.white, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8.h),
                  child: SvgPicture.asset(
                    AppIcons.close,
                    colorFilter:
                        ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            if (widget.onDeleted != null)
              Positioned(
                left: 10.h,
                top: 10.h,
                child: GestureDetector(
                  onTap: () => showWarning(
                      title: 'Bạn có chắc muốn xóa ảnh ?',
                      icon: SvgPicture.asset(AppIcons.binCircle),
                      btnText: 'Xóa',
                      onPressed: () {
                        context.pop();
                        widget.onDeleted?.call();
                      }),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.white, shape: BoxShape.circle),
                    padding: EdgeInsets.all(8.h),
                    child: SvgPicture.asset(
                      AppIcons.bin,
                      height: 24.h,
                      width: 24.h,
                      colorFilter:
                          ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                    ),
                  ),
                ),
              )
          ],
        )
      ],
    );
  }
}
