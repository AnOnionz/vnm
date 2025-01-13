import 'package:fms/core/constant/type_def.dart';
import 'package:fms/features/urgency/domain/entities/urgency_entity.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/repositories/urgency_repository_impl.dart';

class EndUrgencyUsecase extends UseCase<UrgencyEntity?, int> {
  final UrgencyRepositoryImpl _urgencyRepository;

  EndUrgencyUsecase(this._urgencyRepository);

  @override
  Future<Result<UrgencyEntity?>> call(int featureId) {
    return _urgencyRepository.endUrgency(featureId: featureId);
  }
}
