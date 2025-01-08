import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/features/urgency/data/repositories/urgency_repository_impl.dart';
import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';

import '../../../../core/usecase/usecase.dart';

class BeginUrgencyUsecase extends UseCase<UrgencyEntity?, BeginUrgencyParmas> {
  final UrgencyRepositoryImpl _urgencyRepository;

  BeginUrgencyUsecase(this._urgencyRepository);

  @override
  Future<Result<UrgencyEntity?>> call(BeginUrgencyParmas parmas) {
    return _urgencyRepository.beginUrgency(
        featureId: parmas.featureId,
        note: parmas.note,
        featureUrgencyId: parmas.featureUrgencyId);
  }
}

class BeginUrgencyParmas extends Params {
  final int featureId;
  final int featureUrgencyId;
  final String? note;

  BeginUrgencyParmas(
      {required this.featureId, required this.featureUrgencyId, this.note});
}
