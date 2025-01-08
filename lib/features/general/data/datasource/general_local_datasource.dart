import 'package:vnm/core/data_source/local_data_source.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';

abstract class IGeneralLocalDataSource {
  void cacheGeneral(GeneralEntity general);
  void clearGeneral();
  GeneralEntity? getGeneral();
}

class GeneralLocalDataSource
    with LocalDatasource
    implements IGeneralLocalDataSource {
  @override
  void cacheGeneral(GeneralEntity general) {
    db.clearCollection<GeneralEntity>();
    db.addObject<GeneralEntity>(general);
  }

  @override
  void clearGeneral() {
    db.clearCollection<GeneralEntity>();
  }

  @override
  GeneralEntity? getGeneral() {
    final general = db.getObject<GeneralEntity>();

    return general;
  }
}
