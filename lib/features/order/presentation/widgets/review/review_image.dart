import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import '../../../../../core/constant/enum.dart';
import '../../../../../core/widgets/share_button.dart';
import '../../../../general/domain/entities/config_entity.dart';
import '../../../../images/domain/entities/image_dynamic.dart';
import '../../../../images/presentation/widgets/listview_images.dart';
import '../../../../report/domain/entities/photo_entity.dart';
import 'review_container.dart';

class ReviewImage extends StatefulWidget {
  final List<FeaturePhoto> featurePhotos;
  final List<PhotoEntity>? photos;
  final bool enableShare;
  const ReviewImage(
      {super.key,
      required this.featurePhotos,
      this.photos,
      required this.enableShare});

  @override
  State<ReviewImage> createState() => _ReviewProductState();
}

class _ReviewProductState extends State<ReviewImage> {
  final Map<FeaturePhoto, List<PhotoEntity>> _items = {};
  late int totalPrice;

  @override
  void didChangeDependencies() {
    _handlePhotos();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ReviewImage oldWidget) {
    _items.clear();
    _handlePhotos();
    super.didUpdateWidget(oldWidget);
  }

  void _handlePhotos() {
    widget.photos?.forEach((photo) {
      final featurePhoto = widget.featurePhotos
          .firstWhereOrNull((element) => element.id == photo.featurePhotoId);

      if (featurePhoto != null) {
        _items[featurePhoto] = _items[featurePhoto] ?? [];
        _items[featurePhoto]!.add(photo);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return SizedBox.shrink();
    return ReviewContainer(
        margin: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hình ảnh',
              style: context.textTheme.subtitle1,
            ),
            SizedBox(
              height: 14.h,
            ),
            for (final item in _items.entries)
              _PhotosInfoItem(
                enableShare: widget.enableShare,
                featurePhoto: item.key,
                photos: item.value,
              ),
            SizedBox(
              height: 6.h,
            ),
          ],
        ));
  }
}

class _PhotosInfoItem extends StatelessWidget {
  final FeaturePhoto featurePhoto;
  final List<PhotoEntity> photos;
  final bool enableShare;
  const _PhotosInfoItem(
      {required this.photos,
      required this.featurePhoto,
      required this.enableShare});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            featurePhoto.name ?? '',
            style: context.textTheme.body1,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: ListViewImages(
                imagePickerButton: SizedBox(),
                images: photos
                    .where((element) => element.status != SyncStatus.isDeleted)
                    .map((e) => ImageDynamic(
                        id: e.id,
                        uuid: e.dataUuid,
                        dataTimestamp: e.dataTimestamp,
                        path: e.path,
                        networkImage: e.image))
                    .toList(),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: ShareButton(
                enable: enableShare &&
                    photos.any((photo) => photo.status == SyncStatus.synced),
                photos: photos,
              )),
        ],
      ),
    );
  }
}
