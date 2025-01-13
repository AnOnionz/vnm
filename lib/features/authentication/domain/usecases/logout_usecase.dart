import 'package:fms/core/mixins/extension/func_ext.dart';

import '/core/constant/type_def.dart';
import '/core/usecase/usecase.dart';
import '../repositories/authentication_repository.dart';

class LogoutUsecase extends UseCase<bool, void> {
  final AuthenticationRepository repository;

  LogoutUsecase({required this.repository});
  @override
  Future<Result<bool>> call([void params]) async {
    return repository.logout().withLoading();
  }
}
