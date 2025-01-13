import 'package:flutter/material.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/utilities/flex_extention.dart';
import 'package:fms/core/styles/theme.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';

class OosTypeWidget extends StatelessWidget {
  final FeatureOosZone? currentZone;
  final List<FeatureOosZone> zones;
  final void Function(FeatureOosZone zone) onChanged;
  const OosTypeWidget(
      {super.key,
      required this.zones,
      this.currentZone,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      constraints: BoxConstraints(maxHeight: context.percentHeight * 20),
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(16.sqr)),
      child: SingleChildScrollView(
        physics: kPhysics,
        child: DefaultTextStyle(
          style: context.textTheme.subtitle1!
              .copyWith(color: AppColors.black.withOpacity(0.85)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vị trí ghi nhận',
              ),
              for (final zone in zones)
                RadioListTile<FeatureOosZone>(
                  value: zone,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  title: Text(
                    zone.name ?? '',
                  ),
                  splashRadius: 16,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    // active
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    // inactive
                    return '#D9D9D9'.toColor();
                  }),
                  groupValue: currentZone,
                  onChanged: (value) {
                    onChanged(value!);
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
