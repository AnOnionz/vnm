import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/work_place_entity.dart';
import '../../work_place_module.dart';

part 'work_place_event.dart';
part 'work_place_state.dart';

class WorkPlaceBloc extends Bloc<WorkPlaceEvent, WorkPlaceState> {
  WorkPlaceBloc() : super(WorkPlaceState.init()) {
    on<ApplyProject>((event, emit) {
      emit(state.copyWith(entity: event.workPlaceEntity));
      Modular.to.pushNamed(WorkPlaceModule.selectOutlet,
          arguments: event.workPlaceEntity);
    }, transformer: droppable());

    on<ApplyOutlet>((event, emit) {
      emit(state.copyWith(entity: event.workPlaceEntity));
      Modular.to.pushNamed(WorkPlaceModule.selectBooth,
          arguments: event.workPlaceEntity);
    }, transformer: droppable());

    on<ApplyBooth>((event, emit) {
      emit(state.copyWith(entity: event.workPlaceEntity));
    }, transformer: droppable());
  }
}
