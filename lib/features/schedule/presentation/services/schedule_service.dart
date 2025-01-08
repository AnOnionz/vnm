import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';

class ScheduleService {
  final NetworkTimeService timeService = Modular.get<NetworkTimeService>();

  Future<bool> checkSchedules(List<FeatureSchedule>? schedules) async {
    if (schedules == null || schedules.isEmpty) return true;
    final currentTime = await timeService.ntpDateTime();

    bool isValid = true;

    for (final schedule in schedules) {
      if (_isDateTimeValid(currentTime, schedule: schedule)) {
        isValid = true;
        break;
      } else {
        isValid = false;
      }
    }
    return isValid;
  }

  bool _isDateTimeValid(DateTime dataTime,
      {required FeatureSchedule schedule}) {
    return dataTime.isAfter(DateTime.parse(
            dataTime.formatBy(kyMd) + ' ' + schedule.startTime!)) &&
        dataTime.isBefore(
            DateTime.parse(dataTime.formatBy(kyMd) + ' ' + schedule.endTime!));
  }
}
