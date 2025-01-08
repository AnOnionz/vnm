import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vnm/core/responsive/responsive.dart';

import '../../../../core/cache_image_network/cached_image.dart';
import '../../../../core/utilities/overlay.dart';
import '../../../../core/widgets/app_indicator.dart';
import 'image_view_widget.dart';

class ImageThumbnailWidget extends StatefulWidget {
  // final ImageDynamic image;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String? path;
  final VoidCallback? onDeleted;
  final double? width;
  final double? height;
  const ImageThumbnailWidget({
    super.key,
    // required this.image,
    this.width,
    this.height,
    this.onDeleted,
    this.imageUrl,
    this.thumbnailUrl,
    this.path,
  }) : assert(path != null || thumbnailUrl != null);

  @override
  State<ImageThumbnailWidget> createState() => _ImageThumbnailWidgetState();
}

class _ImageThumbnailWidgetState extends State<ImageThumbnailWidget> {
  Future<void> _imagePreview({String? imageUrl, String? path}) async {
    if (imageUrl == null && path == null) return;
    await OverlayManager.showAppDialog(
        builder: (context) => ImageViewWidget(
              path: path,
              url: imageUrl,
              onDeleted: widget.onDeleted,
            ));
  }

  @override
  void initState() {
    super.initState();
    // if (widget.path != null &&
    //     widget.imageUrl == null &&
    //     !File(widget.path!).existsSync()) {
    //   widget.onDeleted?.call();
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.path != null && File(widget.path!).existsSync())
      return GestureDetector(
        onTap: () => _imagePreview(path: widget.path),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.sqr),
            child: SizedBox(
                width: widget.width,
                height: widget.height,
                child: Image.file(
                  File(widget.path!),
                  fit: BoxFit.cover,
                ))),
      );

    return GestureDetector(
      onTap: () => _imagePreview(imageUrl: widget.imageUrl),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(12.sqr),
          child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: CachedImage(
                fit: BoxFit.cover,
                placeholder: (p0, p1) => SizedBox(
                  width: 60.h,
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIndicator(),
                    ],
                  ),
                ),
                imageUrl: widget.thumbnailUrl!,
              ))),
    );
  }
}
