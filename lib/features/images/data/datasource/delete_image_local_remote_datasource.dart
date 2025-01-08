import 'package:vnm/core/data_source/local_data_source.dart';
import 'package:vnm/features/report/domain/entities/photo_entity.dart';

abstract class IDeteleImageLocalDataSource {
  void deleteLocalPhoto<T>({required int id});
  bool canDeleteLocalPhoto<T>({required int id});
}

class DeletePhotoLocalDataSource
    with LocalDatasource
    implements IDeteleImageLocalDataSource {
  @override
  void deleteLocalPhoto<T>({required int id}) {
    db.deleteObject<PhotoEntity>(id: id);
  }

  @override
  bool canDeleteLocalPhoto<T>({required int id}) {
    final photo = db.getObject<PhotoEntity>(id: id);
    return photo != null;
  }
}
