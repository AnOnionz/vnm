import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/repositories/urgency_repository_impl.dart';

class CurrentUrgencyUsecase extends UseCase<UrgencyEntity?, int> {
  final UrgencyRepositoryImpl _urgencyRepository;

  CurrentUrgencyUsecase(this._urgencyRepository);

  @override
  Future<Result<UrgencyEntity?>> call(int featureId) {
    return _urgencyRepository.currentUrgency(featureId: featureId);
  }
}
