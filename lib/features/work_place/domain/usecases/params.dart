import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/work_place/domain/entities/work_place_entity.dart';

class WorkPlaceParams extends Params {
  final WorkPlaceEntity enitty;

  WorkPlaceParams({required this.enitty});
}
