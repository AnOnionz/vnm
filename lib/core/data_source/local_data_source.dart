import 'package:vnm/core/database/database.dart';

mixin LocalDatasource {
  final Database db = Database.instance;
}
