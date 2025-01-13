import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/mapper.dart';
import 'package:fms/core/data_source/local_data_source.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/services/network_time/network_time_service.dart';
import 'package:fms/core/utilities/parser.dart';
import 'package:fms/core/widgets/app_bar.dart';
import 'package:fms/core/widgets/sliver_search_widget.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/note/domain/entities/note_entity.dart';
import 'package:fms/features/note/presentation/cubit/note_cubit.dart';
import 'package:fms/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/constant/icons.dart';
import '../../../../core/styles/theme.dart';
import '../../../../core/widgets/app_indicator.dart';
import '../../../../core/widgets/button/flat.dart';
import '../../../../core/widgets/data_load_error_widget.dart';
import '../../../../core/widgets/popup.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../../../report/domain/entities/photo_entity.dart';
import '../widgets/note_item.dart';

class NotePage extends StatefulWidget {
  final GeneralFeatureData entity;
  NotePage({super.key, required this.entity});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with LocalDatasource {
  final networkTimeService = Modular.get<NetworkTimeService>();
  final NoteCubit _cubit = Modular.get();
  late final featureMultimedias =
      (widget.entity.feature.featureMultimedias ?? [])
          .sorted((a, b) => a.ordinal! - b.ordinal!);
  late List<FeatureMultimedia> _featureMultimediasValid = featureMultimedias;
  late Map<int, NoteEntity> entryNotes = {};
  late final Map<int, NoteEntity> notes = {};
  late final Map<int, List<PhotoEntity>> photos = {};
  final ValueNotifier<bool> isWatermarking = ValueNotifier(false);
  Completer<bool> _completer = Completer();

  bool get isNoteActive => notes.values.any((note) {
        if (note.isTextFieldRequired) {
          return note.status == SyncStatus.isNoSynced &&
              !note.value.isEmptyOrNull;
        }
        if (!note.isTextFieldRequired) {
          return note.status == SyncStatus.isNoSynced;
        }
        return true;
      });

  bool get isPhotoActive => photos.values.any((photos) =>
      photos.isNotEmpty &&
      photos.any((photo) =>
          photo.status == SyncStatus.isNoSynced ||
          photo.status == SyncStatus.isDeleted));

  bool get isActive =>
      !notes.values.any((note) {
        return note.isTextFieldRequired &&
            note.status == SyncStatus.isNoSynced &&
            note.value.isEmptyOrNull;
      }) &&
      (isNoteActive || isPhotoActive);

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() {
    _cubit.fetchNotes(
        general: widget.entity.general, feature: widget.entity.feature);
  }

  void saveData() {
    FocusManager.instance.primaryFocus?.unfocus();
    _cubit.saveNotes(
        notes: notes.values.toList(),
        photos: photos.values.toList().expand((element) => element).toList(),
        feature: widget.entity.feature);
  }

  Future<void> onFetchSuccess(
      (List<NoteEntity> notes, List<PhotoEntity> photos) data) async {
    final photoGroup = data.$2.groupBy<int, PhotoEntity>((photo) {
      return photo.featurePhotoId;
    });

    featureMultimedias.forEach((featureMultimedia) {
      photos[featureMultimedia.id!] = photoGroup[featureMultimedia.id!] ?? [];
      photos[featureMultimedia.id!]!.forEach((element) {
        element = element.copyWith(featureId: widget.entity.feature.id);
      });
      setState(() {});
    });

    await Future.forEach(featureMultimedias, (featureMultimedia) async {
      await Future.delayed(100.milliseconds);
      final timestamp = await networkTimeService.ntpDateTime();
      final note = data.$1.firstWhereOrNull(
          (element) => element.featureMultimediaId == featureMultimedia.id!);

      if (note != null) {
        notes[featureMultimedia.id!] = note.copyWith(
            isTextFieldRequired: featureMultimedia.isTextFieldRequired!);
      } else {
        final hasPhotoNoSynced = photos[featureMultimedia.id!] != null &&
            photos[featureMultimedia.id!]!.any((photo) =>
                photo.status == SyncStatus.isNoSynced ||
                photo.status == SyncStatus.isDeleted);

        notes[featureMultimedia.id!] = NoteEntity(
            dataUuid: Uuid().v1(),
            dataTimestamp: timestamp,
            attendanceId: widget.entity.general.attendance!.id,
            featureId: widget.entity.feature.id,
            isTextFieldRequired: featureMultimedia.isTextFieldRequired!,
            featureMultimediaId: featureMultimedia.id!,
            status:
                hasPhotoNoSynced ? SyncStatus.isNoSynced : SyncStatus.synced);
      }
    });

    // Fx.log(photos);

    setState(() {
      entryNotes = Map.from(notes);
      // Fx.log(entryNotes);
    });

    if (!_completer.isCompleted) _completer.complete(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: DefaultAppBar(title: widget.entity.feature.name!),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocConsumer<NoteCubit, NoteState>(
                  bloc: _cubit,
                  listener: (context, state) {
                    if (state is NoteSuccess) {
                      onFetchSuccess(state.data);
                    }
                    if (state is NoteFailure) {
                      showFailure(
                        title: 'Tải dữ liệu thất bại',
                        icon: SvgPicture.asset(AppIcons.failure),
                        message: state.failure.message,
                        btnText: 'Thử lại',
                        onPressed: () async {
                          await Future.delayed(
                            300.milliseconds,
                            () => fetchNotes(),
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is NoteSuccess && _completer.isCompleted) {
                      return CustomScrollView(
                        physics: kPhysics,
                        slivers: [
                          SliverSearchWidget<FeatureMultimedia>(
                            data: featureMultimedias,
                            searchBy: (object) => object.title ?? '',
                            onSearched: (newData) {
                              setState(() {
                                _featureMultimediasValid = newData;
                              });
                            },
                          ),
                          SliverPadding(
                              padding: EdgeInsets.only(bottom: 5.h),
                              sliver: SliverList.builder(
                                itemCount: featureMultimedias.length,
                                itemBuilder: (context, index) {
                                  final featureMultimedia =
                                      featureMultimedias[index];
                                  final noteItem =
                                      notes[featureMultimedia.id!]!;
                                  final isShowDesc =
                                      !entryNotes[featureMultimedia.id!]!
                                              .value
                                              .isEmptyOrNull &&
                                          noteItem.isTextFieldRequired;
                                  if (!_featureMultimediasValid
                                      .contains(featureMultimedia)) {
                                    return SizedBox.shrink();
                                  }
                                  return NoteItem(
                                    entity: featureMultimedia,
                                    note: noteItem,
                                    description: isShowDesc
                                        ? 'Ghi chú này không thể để trống. Nếu bạn đã xóa dữ liệu, hãy nhập lại.'
                                        : null,
                                    feature: widget.entity.feature,
                                    photos: photos[featureMultimedia.id!]!,
                                    onChangeTextfield: (value) {
                                      final isEdited =
                                          (entryNotes[featureMultimedia.id!]!
                                                      .value ??
                                                  '') !=
                                              value;

                                      if (isEdited) {
                                        notes[featureMultimedia.id!] =
                                            noteItem.copyWith(
                                                value: Value(
                                                    object: noteItem
                                                            .isTextFieldRequired
                                                        ? value.trimLeft()
                                                        : value),
                                                status: SyncStatus.isNoSynced);
                                      }

                                      if (!isEdited) {
                                        notes[featureMultimedia.id!] =
                                            noteItem.copyWith(
                                          value: Value(object: value),
                                          status:
                                              entryNotes[featureMultimedia.id!]!
                                                  .status,
                                        );
                                      }
                                      setState(() {});
                                    },
                                    onPickImage: (file) async {
                                      photos[featureMultimedia.id!]!
                                          .add(PhotoEntity(
                                        dataUuid: Uuid().v1(),
                                        featureId: widget.entity.feature.id!,
                                        attendanceId: widget
                                            .entity.general.attendance!.id!,
                                        dataTimestamp: file.dataTimestamp,
                                        path: file.path,
                                        featurePhotoId: featureMultimedia.id!,
                                      ));
                                      notes[featureMultimedia.id!] =
                                          noteItem.copyWith(
                                              status: SyncStatus.isNoSynced);
                                      setState(() {});
                                    },
                                    onDeleteImage: (image) {
                                      if (image.id != null) {
                                        final photo =
                                            photos[featureMultimedia.id!]!
                                                .firstWhere((element) =>
                                                    element.dataUuid ==
                                                    image.uuid);

                                        photo.status = SyncStatus.isDeleted;
                                        notes[featureMultimedia.id!] =
                                            noteItem.copyWith(
                                                status: SyncStatus.isNoSynced);
                                      } else {
                                        photos[featureMultimedia.id!]!
                                            .removeWhere((photo) =>
                                                photo.dataUuid == image.uuid);

                                        db.deleteObject<PhotoEntity>(
                                            id: fastHash(image.uuid));
                                      }

                                      setState(() {});
                                    },
                                    isWatermark:
                                        featureMultimedia.isWatermarkRequired!,
                                    isWatermarking:
                                        featureMultimedia.isWatermarkRequired!
                                            ? isWatermarking
                                            : null,
                                  );
                                },
                              ))
                        ],
                      );
                    }
                    if (state is NoteFailure) {
                      return Center(
                        child:
                            DataLoadErrorWidget(onPressed: () => fetchNotes()),
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
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
