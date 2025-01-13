import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/data_source/local_data_source.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/styles/theme.dart';
import 'package:fms/core/widgets/app_bar.dart';
import 'package:fms/core/widgets/app_indicator.dart';
import 'package:fms/core/widgets/sliver_search_widget.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/report/domain/entities/photo_entity.dart';
import 'package:fms/features/report/presentation/widgets/photo_item.dart';
import 'package:fms/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/utilities/parser.dart';
import '../../../../core/widgets/button/flat.dart';
import '../../../../core/widgets/data_load_error_widget.dart';
import '../../../../core/widgets/popup.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../cubit/report_cubit.dart';

class ReportPage extends StatefulWidget {
  final GeneralFeatureData entity;
  ReportPage({super.key, required this.entity});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with LocalDatasource {
  final ReportCubit _cubit = Modular.get();

  late final featurePhotos = (widget.entity.feature.featurePhotos ?? [])
      .sorted((a, b) => a.ordinal! - b.ordinal!);

  late List<FeaturePhoto> _featurePhotosValid = featurePhotos;

  late final Map<int, List<PhotoEntity>> reports = {};
  final ValueNotifier<bool> isWatermarking = ValueNotifier(false);

  bool get isActive => reports.values.any((photos) =>
      photos.isNotEmpty &&
      photos.any((photo) =>
          photo.status == SyncStatus.isNoSynced ||
          photo.status == SyncStatus.isDeleted));

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  void fetchPhotos() {
    _cubit.fetchPhotos(
        general: widget.entity.general, feature: widget.entity.feature);
  }

  void saveData() {
    _cubit.savePhotos(
        items: reports.values.toList().expand((element) => element).toList(),
        feature: widget.entity.feature);
  }

  void onFetchSuccess(List<PhotoEntity> data) {
    final photoGroup = groupBy<PhotoEntity, int>(
      data,
      (photo) {
        return photo.featurePhotoId;
      },
    );

    featurePhotos.forEach((featurePhoto) {
      setState(() {
        reports[featurePhoto.id!] = photoGroup[featurePhoto.id!] ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: DefaultAppBar(title: widget.entity.feature.name!),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocConsumer<ReportCubit, ReportState>(
                  bloc: _cubit,
                  listener: (context, state) {
                    if (state is ReportSuccess) {
                      onFetchSuccess(state.photos);
                    }
                    if (state is ReportFailure) {
                      showFailure(
                        title: 'Tải dữ liệu thất bại',
                        icon: SvgPicture.asset(AppIcons.failure),
                        message: state.failure.message,
                        btnText: 'Thử lại',
                        onPressed: () async {
                          await Future.delayed(
                            300.milliseconds,
                            () => fetchPhotos(),
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ReportSuccess) {
                      return CustomScrollView(
                        physics: kPhysics,
                        slivers: [
                          SliverSearchWidget<FeaturePhoto>(
                            data: featurePhotos,
                            searchBy: (object) => object.name ?? '',
                            onSearched: (newData) {
                              setState(() {
                                _featurePhotosValid = newData;
                              });
                            },
                          ),
                          SliverPadding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              sliver: SliverList.builder(
                                itemCount: featurePhotos.length,
                                itemBuilder: (context, index) {
                                  final photoItem = featurePhotos[index];
                                  if (!_featurePhotosValid
                                      .contains(photoItem)) {
                                    return SizedBox.shrink();
                                  }
                                  return PhotoItem(
                                    entity: photoItem,
                                    enableShare: true,
                                    feature: widget.entity.feature,
                                    photos: reports[photoItem.id!]!,
                                    onAdded: (file) async {
                                      reports[photoItem.id!]!.add(PhotoEntity(
                                        dataUuid: Uuid().v1(),
                                        dataTimestamp: file.dataTimestamp,
                                        path: file.path,
                                        featurePhotoId: photoItem.id!,
                                      ));
                                      setState(() {});
                                    },
                                    onDeleted: (image) {
                                      if (image.id != null) {
                                        final photo = reports[photoItem.id!]!
                                            .firstWhere((element) =>
                                                element.dataUuid == image.uuid);
                                        photo.status = SyncStatus.isDeleted;
                                      } else {
                                        reports[photoItem.id!]!.removeWhere(
                                            (photo) =>
                                                photo.dataUuid == image.uuid);

                                        db.deleteObject<PhotoEntity>(
                                            id: fastHash(image.uuid));
                                      }

                                      setState(() {});
                                    },
                                    isWatermark: photoItem.isWatermarkRequired!,
                                    isWatermarking:
                                        photoItem.isWatermarkRequired!
                                            ? isWatermarking
                                            : null,
                                  );
                                },
                              ))
                        ],
                      );
                    }
                    if (state is ReportFailure) {
                      return Center(
                        child:
                            DataLoadErrorWidget(onPressed: () => fetchPhotos()),
                      );
                    }
                    return Center(child: AppIndicator());
                  },
                ),
              ),
              ScheduleBuilder(
                  feature: widget.entity.feature,
                  builder: (callback) => ValueListenableBuilder(
                      valueListenable: isWatermarking,
                      builder: (context, value, _) {
                        return FlatButton(
                          onPressed: isWatermarking.value == false && isActive
                              ? () => callback(saveData)
                              : null,
                          name: 'Lưu',
                          color: AppColors.primary,
                          disableColor: AppColors.potPourri,
                          disableTextColor: AppColors.delRio,
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
