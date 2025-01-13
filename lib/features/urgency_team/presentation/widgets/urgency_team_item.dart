import 'package:flutter/material.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/features/urgency/domain/entities/urgency_entity.dart';

class UrgencyTeamItem extends StatelessWidget {
  final UrgencyEntity urgency;
  const UrgencyTeamItem({super.key, required this.urgency});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: context.screenWidth),
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 18.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.sqr),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (urgency.user != null)
            _buildItem(context, key: 'Nhân sự: ', value: urgency.user!.name!),
          _buildItem(context,
              key: 'Ngày: ', value: urgency.startAt.formatBy(kdMy)),
          if (urgency.featureUrgency != null)
            _buildItem(context,
                key: 'Lý do: ', value: urgency.featureUrgency!.name!),
          if (urgency.note != null)
            _buildItem(context, key: 'Ghi chú: ', value: urgency.note!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _buildItem(context,
                    key: 'T/gian bắt đầu: ',
                    value: urgency.startAt.formatBy(khms)),
              ),
              Flexible(
                child: _buildItem(context,
                    key: 'T/gian kết thúc: ',
                    valueColor: urgency.endAt != null ? null : AppColors.nobel,
                    value: urgency.endAt != null
                        ? urgency.endAt!.formatBy(khms)
                        : '__:__'),
              ),
            ],
          ),
          if (urgency.endAt != null)
            _buildItem(context,
                key: 'Thời gian rời vị trí: ',
                value: urgency.endAt!
                    .difference(urgency.startAt)
                    .toString()
                    .split('.')
                    .first
                    .padLeft(8, '0')),
          if (urgency.endAt != null)
            Text('Đã kết thúc',
                style: context.textTheme.body2
                    ?.copyWith(color: AppColors.royalBlue)),
          if (urgency.endAt == null)
            Text('Đang diễn ra',
                style: context.textTheme.body2?.copyWith(color: AppColors.red)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context,
      {required String key, required String value, Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: RichText(
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: key,
              style: context.textTheme.body2?.copyWith(color: AppColors.nobel),
              children: [
                TextSpan(
                    text: value,
                    style: context.textTheme.body2?.copyWith(
                        color: valueColor ?? AppColors.black,
                        fontWeight: FontWeight.w500))
              ])),
    );
  }
}
