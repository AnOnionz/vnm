import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/data/repository/general_repository_impl.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';

class CreateGeneralUseCase extends UseCase<void, GeneralEntity> {
  final GeneralRepository repository;

  CreateGeneralUseCase(this.repository);
  @override
  Future<Result<void>> call(GeneralEntity params) {
    return repository.createGeneral(params);
  }
}
