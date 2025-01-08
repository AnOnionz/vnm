import '../../../../core/constant/type_def.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../urgency/domain/entities/urgency_entity.dart';
import '../../data/repositories/urgency_team_repository_impl.dart';

class GetUrgencyTeamUsecase extends UseCase<List<UrgencyEntity>, int> {
  final UrgencyTeamRepositoryImpl _urgencyTeamRepository;

  GetUrgencyTeamUsecase(this._urgencyTeamRepository);

  Future<Result<List<UrgencyEntity>>> call(int featureId) {
    return _urgencyTeamRepository.getReport(featureId: featureId);
  }
}
