import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/data/repository/general_repository_impl.dart';

class ClearGeneralUseCase extends UseCase<void, void> {
  final GeneralRepository repository;

  ClearGeneralUseCase(this.repository);
  @override
  Future<Result<void>> call([void params]) {
    return repository.clearGeneral();
  }
}
