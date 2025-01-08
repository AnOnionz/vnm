import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/statistic/domain/entities/statistic_entity.dart';

import '../../data/repositories/statistic_repository_impl.dart';

class FetchEmployeeStatisticUseCase
    extends UseCase<StatisticEntity, EmployeeStatisticParams> {
  final StatisticRepositoryImpl _repository;

  FetchEmployeeStatisticUseCase(this._repository);
  @override
  Future<Result<StatisticEntity>> call(EmployeeStatisticParams params) {
    return _repository.fetchEmployeeStatistic(
        featureId: params.featureId, employeeId: params.employeeId);
  }
}

class EmployeeStatisticParams {
  final int featureId;
  final int employeeId;

  EmployeeStatisticParams({required this.featureId, required this.employeeId});
}
