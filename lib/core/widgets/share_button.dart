import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/styles/theme.dart';
import 'package:fms/core/utilities/overlay.dart';
import 'package:fms/core/utilities/share.dart';
import 'package:fms/core/widgets/button/flat.dart';
import 'package:fms/core/widgets/button/outline.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/report/domain/entities/photo_entity.dart';
import '../constant/colors.dart';
import '../constant/enum.dart';

class ShareButton extends StatelessWidget {
  final bool enable;
  final List<PhotoEntity> photos;
  const ShareButton({super.key, required this.enable, required this.photos});

  List<PhotoEntity> get _photos =>
      photos.where((element) => element.status == SyncStatus.synced).toList();

  Future<void> _onSharePhotoSynced(BuildContext context) async {
    OverlayManager.showSheet(body: StatefulBuilder(builder: (_, setState) {
      return _ShareBodyWidget(_photos);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 100.milliseconds,
      child: enable
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sqr)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      fixedSize: Size(38.w, 38.w)),
                  onPressed: () => _onSharePhotoSynced(context),
                  child: Center(child: SvgPicture.asset(AppIcons.share))),
            )
          : SizedBox.shrink(),
    );
  }
}

class _ShareBodyWidget extends StatefulWidget {
  final List<PhotoEntity> photos;
  const _ShareBodyWidget(this.photos);

  @override
  State<_ShareBodyWidget> createState() => __ShareBodyWidgetState();
}

class __ShareBodyWidgetState extends State<_ShareBodyWidget> {
  Map<String, bool> _files = {};
  bool get _selectAll =>
      _files.entries.isNotEmpty &&
      _files.entries.every((element) => element.value == true);
  bool canSelectAll = false;

  @override
  void initState() {
    super.initState();
    _initialPhotos();
  }

  Future<void> _initialPhotos() async {
    final futures = widget.photos.map((e) async {
      final filePath = await e.imageUrl;
      if (filePath.isNotEmpty) {
        _files[filePath] = false;
      }
    });

    await Future.wait(futures);
    canSelectAll = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = (OverlayManager.currentContext ?? context).screenWidth - 40.w;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: Text('Chia sẻ hình ảnh',
              style: context.textTheme.h2?.copyWith(
                  color: AppColors.nightRider, fontWeight: FontWeight.bold)),
        ),
        if (canSelectAll)
          RadioListTile(
            value: true,
            title: Text('Chọn tất cả'),
            toggleable: true,
            fillColor: WidgetStatePropertyAll(AppColors.royalBlue),
            groupValue: _selectAll,
            onChanged: (value) {
              setState(() {
                _files.updateAll((k, v) => value ?? false);
              });
            },
          ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            child: SingleChildScrollView(
                physics: kPhysics,
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 10.w,
                  children: _files.entries.map((item) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _files[item.key] = !item.value;
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12.sqr),
                              child: Column(
                                children: [
                                  SizedBox(
                                      width: (width - 3 * 8.w) / 4,
                                      height: (width - 3 * 8.w) / 4,
                                      child: Image.file(File(item.key),
                                          fit: BoxFit.cover)),
                                ],
                              )),
                          if (_files[item.key] == true)
                            Positioned(
                              key: ValueKey(item.key),
                              left: 6.w,
                              top: 6.w,
                              child: SvgPicture.asset(AppIcons.checked,
                                  height: 20),
                            )
                        ],
                      ),
                    );
                  }).toList(),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: Center(
            child: Text('Chọn hình bạn muốn chia sẻ',
                style:
                    context.textTheme.body1?.copyWith(color: AppColors.nero)),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: OutlineButton(
                onPressed: () {
                  OverlayManager.hideDialog();
                },
                name: 'Hủy',
                color: AppColors.primary),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: FlatButton(
              onPressed: _files.entries.any((element) => element.value)
                  ? () async {
                      final xfiles = _files.entries
                          .where((e) => e.value)
                          .map((e) => XFile(e.key))
                          .toList();

                      OverlayManager.hideDialog();
                      final result =
                          await ShareUtils.ShareXFiles(context, files: xfiles);

                      if (result.status == ShareResultStatus.success) {
                        OverlayManager.showSimpleToast(
                            content: Center(
                                child: SvgPicture.asset(AppIcons.success)),
                            background: AppColors.royalBlue.withOpacity(0.7),
                            context: OverlayManager.currentContext ?? context);
                      }
                      if (result.status == ShareResultStatus.unavailable) {
                        OverlayManager.showSimpleToast(
                            msg: 'Thất bại',
                            background: AppColors.brickRed.withOpacity(0.7),
                            context: OverlayManager.currentContext ?? context);
                      }
                    }
                  : null,
              name: 'Chia sẻ',
              color: AppColors.primary,
              disableTextColor: AppColors.delRio,
              disableColor: AppColors.potPourri,
            ),
          )
        ])
      ],
    );
  }
}
