import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/data/repository/general_repository_impl.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';

class GetGeneralUseCase extends UseCase<GeneralEntity?, void> {
  final GeneralRepository repository;

  GetGeneralUseCase(this.repository);
  @override
  Future<Result<GeneralEntity?>> call([void params]) {
    return repository.getLocalGeneral();
  }
}
