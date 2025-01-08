import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';

import '../../../../core/constant/type_def.dart';

abstract class UrgencyTeamRepository {
  Future<Result<List<UrgencyEntity>>> getReport({required int featureId});
}
