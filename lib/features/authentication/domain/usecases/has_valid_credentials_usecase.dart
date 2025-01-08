import '/core/constant/type_def.dart';
import '/core/usecase/usecase.dart';
import '../repositories/authentication_repository.dart';

class HasValidCredentialsUsecase extends UseCase<bool, void> {
  final AuthenticationRepository repository;

  HasValidCredentialsUsecase({required this.repository});
  @override
  Future<Result<bool>> call([void params]) async {
    return repository.hasValidCredentials();
  }
}
