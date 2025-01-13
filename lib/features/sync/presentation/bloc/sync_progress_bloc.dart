import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/mixins/extension/num_ext.dart';
import 'package:fms/features/sync/domain/usecases/sync_usecase.dart';
import 'package:fms/features/sync/presentation/bloc/sync_bloc.dart';

import '../../../../core/errors/failure.dart';

part 'sync_progress_event.dart';
part 'sync_progress_state.dart';

class SyncProgressBloc extends Bloc<SyncProgressEvent, SyncProgressState> {
  final SyncUseCase _synchronized;
  final SyncBloc _syncBloc;
  final syncDelayTime = 180.seconds;

  SyncProgressBloc(this._syncBloc, this._synchronized)
      : super(SyncProgressInitial()) {
    on<SyncProgressStart>(_onSyncProgressStart, transformer: droppable());
    on<SyncProgressSilent>(_onSyncProgressSilent, transformer: droppable());
  }

  Timer? _timer;

  FutureOr<void> _onSyncProgressStart(
      SyncProgressStart event, Emitter<SyncProgressState> emit) async {
    emit(SyncProgressLoading());
    await _synchronized(_syncBloc.state.data)
      ..fold((failure) => emit(SyncProgressFailure(failure)), (data) {
        emit(SyncProgressSuccess());
        _timer?.cancel();
        _syncBloc.add(SyncStarted());
      });
  }

  FutureOr<void> _onSyncProgressSilent(
      SyncProgressSilent event, Emitter<SyncProgressState> emit) async {
    if (state is! SyncProgressLoading &&
        _syncBloc.state.status == SyncStatus.isNoSynced) {
      emit(SyncProgressLoading());
      await _synchronized(_syncBloc.state.data)
        ..fold((failure) async {
          emit(SyncProgressSuccess());
          _timer?.cancel();
          _timer = Timer(syncDelayTime, () {
            add(SyncProgressSilent());
          });
        }, (data) {
          emit(SyncProgressSuccess());
        });
    }
  }
}
