import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';
import 'package:vnm/features/urgency/presentation/cubit/urgency_cubit.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/utilities/overlay.dart';
import '../../../../core/widgets/button/flat.dart';
import '../../../../core/widgets/switch/advanced_switch.dart';
import '../../../note/presentation/widgets/note_text_field.dart';
import 'stop_watch.dart';

class UrgencyItem extends StatefulWidget {
  final FeatureEntity feature;
  final FeatureUrgency featureUrgency;
  final UrgencyEntity? urgency;
  final UrgencyCubit urgencyCubit;

  const UrgencyItem(
      {super.key,
      required this.feature,
      required this.featureUrgency,
      required this.urgency,
      required this.urgencyCubit});

  @override
  State<UrgencyItem> createState() => _UrgencyItemState();
}

class _UrgencyItemState extends State<UrgencyItem> {
  bool get isActive =>
      isUrgencing &&
      widget.urgency!.featureUrgencyId == widget.featureUrgency.id;
  bool get isUrgencing => widget.urgency != null;

  late final ValueNotifier<bool> controller = ValueNotifier(isActive);

  @override
  void didChangeDependencies() {
    setState(() {
      controller.value = isActive;
    });
    super.didChangeDependencies();
  }

  void showSheetStart(BuildContext context, {bool? isNoteRequired}) {
    final _controller = TextEditingController();
    String? note;
    OverlayManager.showSheet(
        body: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNoteRequired != true)
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 13.h),
                  child: Text('XÁC NHẬN',
                      style: context.textTheme.h2
                          ?.copyWith(color: AppColors.nightRider)),
                ),
                Text(
                  'Xác nhận tạo báo cáo khẩn ?',
                  textAlign: TextAlign.center,
                  style:
                      context.textTheme.body1?.copyWith(color: AppColors.nero),
                ),
              ],
            ),
          if (isNoteRequired == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Text('Ghi chú',
                      style: context.textTheme.h2
                          ?.copyWith(color: AppColors.nightRider)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: NoteTextField(
                    controller: _controller,
                    maxLength: 500,
                    onChanged: (value) => setState(() => note = value),
                  ),
                )
              ],
            ),
          Text(
            'Vui lòng kết thúc khi bạn quay trở lại',
            textAlign: TextAlign.center,
            style: context.textTheme.body1?.copyWith(color: AppColors.nero),
          ),
          SizedBox(height: 32.h),
          ScheduleBuilder(
            feature: widget.feature,
            showBackground: false,
            isValidateStart: false,
            builder: (callback) => FlatButton(
              onPressed: isNoteRequired == true &&
                      (note.isEmptyOrNull || note!.trim().isEmpty)
                  ? null
                  : () => callback(() {
                        widget.urgencyCubit.beginUrgency(
                            featureId: widget.feature.id!,
                            featureUrgencyId: widget.featureUrgency.id!,
                            note: note);
                        context.pop();
                      }),
              name: 'Xác nhận',
              color: '#427FDA'.toColor(),
              disableColor: AppColors.solitude,
              disableTextColor: '#C8C8C8'.toColor(),
            ),
          )
        ],
      );
    }));
  }

  void showSheetEnd(BuildContext context) {
    OverlayManager.showSheet(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.h, bottom: 13.h),
          child: Text('KẾT THÚC',
              style:
                  context.textTheme.h2?.copyWith(color: AppColors.nightRider)),
        ),
        Text(
          'Bạn muốn kết thúc báo cáo khẩn ?',
          textAlign: TextAlign.center,
          style: context.textTheme.body1?.copyWith(color: AppColors.nero),
        ),
        SizedBox(height: 32.h),
        FlatButton(
            onPressed: () {
              widget.urgencyCubit.endUrgency(featureId: widget.feature.id!);
              context.pop();
            },
            name: 'Kết thúc',
            color: AppColors.primary)
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUrgencing && !isActive
          ? null
          : () => isActive
              ? showSheetEnd(context)
              : showSheetStart(context,
                  isNoteRequired: widget.featureUrgency.isNoteRequired),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(52.sqr),
            boxShadow: [
              BoxShadow(
                  color: '#8A959E'.toColor(0.25),
                  offset: Offset(10, 7),
                  blurRadius: 24)
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    widget.featureUrgency.name!,
                    style: context.textTheme.subtitle1,
                  ),
                ),
              ),
              AbsorbPointer(
                child: AdvancedSwitch(
                  controller: controller,
                  initialValue: isActive,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.aliceBlue,
                  activeChild: StopWatch(
                    startAt: widget.urgency?.startAt,
                  ),
                  inactiveChild: SizedBox.shrink(),
                  height: 44.h,
                  thumb: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (_, value, __) {
                      return Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20.sqr),
                            border: Border.all(
                                color: AppColors.black.withOpacity(0.04)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 1.5,
                                  color: AppColors.black.withOpacity(0.05)),
                              BoxShadow(
                                  offset: Offset(0, 1.5),
                                  blurRadius: 1.5,
                                  color: AppColors.black.withOpacity(0.08)),
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 11,
                                  color: AppColors.black.withOpacity(0.08))
                            ]),
                        child: FittedBox(
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Text(
                              '${value ? "On" : "Off"}',
                              style: context.textTheme.button2
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  borderRadius: BorderRadius.circular(26.sqr),
                  width: 30.wPerc,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
