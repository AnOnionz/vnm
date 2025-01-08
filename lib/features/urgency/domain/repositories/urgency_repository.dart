import '../../../../core/constant/type_def.dart';
import '../entities/urgency_entity.dart';

abstract class UrgencyRepository {
  Future<Result<UrgencyEntity?>> beginUrgency(
      {required int featureId, required int featureUrgencyId, String? note});
  Future<Result<UrgencyEntity?>> endUrgency({required int featureId});
  Future<Result<UrgencyEntity?>> currentUrgency({required int featureId});
}
