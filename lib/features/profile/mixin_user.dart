import 'package:vnm/core/database/database.dart';
import 'package:vnm/features/statistic/domain/entities/employee_entity.dart';

mixin UserMixin {
  EmployeeUserEntity? get user =>
      Database.instance.getObject<EmployeeEntity>()?.user;
}
