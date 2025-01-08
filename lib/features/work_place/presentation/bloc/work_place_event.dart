part of 'work_place_bloc.dart';

sealed class WorkPlaceEvent {
  final WorkPlaceEntity workPlaceEntity;
  const WorkPlaceEvent(this.workPlaceEntity);
}

class ApplyProject extends WorkPlaceEvent {
  ApplyProject(super.workPlaceEntity);
}

class ApplyOutlet extends WorkPlaceEvent {
  ApplyOutlet(super.workPlaceEntity);
}

class ApplyBooth extends WorkPlaceEvent {
  ApplyBooth(super.workPlaceEntity);
}
