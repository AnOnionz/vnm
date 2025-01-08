import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/widgets/notifications.dart';
import 'package:vnm/features/crawl/domain/usecases/get_quantities_not_completed_usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/generic_data/domain/usecases/get_generic_data_not_completed_usecase.dart';
import 'package:vnm/features/home/home_module.dart';
import 'package:vnm/features/note/domain/usecases/get_notes_not_completed_usecase.dart';
import 'package:vnm/features/oos/domain/usecases/get_oos_not_completed_usecase.dart';
import 'package:vnm/features/profile/mixin_user.dart';
import 'package:vnm/features/report/domain/usecases/get_photos_not_completed_usecase.dart';
import 'package:vnm/features/sampling/domain/usecases/get_samplings_not_completed_usecase.dart';
import 'package:vnm/features/schedule/presentation/services/schedule_service.dart';
import 'package:vnm/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:vnm/features/sync/sync_module.dart';

import '../../../../core/services/connectivity/connectivity_service.dart';
import '../../../../core/widgets/popup.dart';
import '../../../profile/profile_module.dart';
import '../../../urgency/domain/usecases/current_urgency_usecase.dart';
import '../../domain/entities/general_item_data.dart';

part 'necessary_event.dart';
part 'necessary_state.dart';

class NecessaryBloc extends Bloc<NecessaryEvent, NecessaryState>
    with GeneralDataMixin, UserMixin {
  final GetPhotosNotCompletedUsecase getPhotosNotCompleted;
  final GetNotesNotCompletedUsecase getNotesNotCompleted;
  final GetQuantitiesNotCompletedUsecase getQuantitiesNotCompleted;
  final GetSamplingsNotCompletedUsecase getSamplingsNotCompleted;
  final CurrentUrgencyUsecase getCurrentUrgencyUsecase;
  final GetGenericDataNotCompletedUsecase getGenericDataNotCompleted;
  final GetOosNotCompletedUsecase getOosNotCompleted;
  final SyncBloc _syncBloc;

  StreamSubscription<NecessaryState>? subscription;
  NecessaryBloc(
      this._syncBloc,
      this.getPhotosNotCompleted,
      this.getNotesNotCompleted,
      this.getQuantitiesNotCompleted,
      this.getSamplingsNotCompleted,
      this.getCurrentUrgencyUsecase,
      this.getGenericDataNotCompleted,
      this.getOosNotCompleted)
      : super(NecessaryInit()) {
    on<NecessaryIn>(onNecessaryIn, transformer: droppable());
    on<NecessaryOut>(onNecessaryOut, transformer: droppable());
    on<NecessarySignOut>(onNecessarySignOut, transformer: droppable());

    subscription = stream.listen((state) {
      if (state is NecessaryLockIn) {
        final action = () {
          Modular.to.pushNamed(
            '/${state.feature.type!.name}/',
            arguments:
                GeneralFeatureData(general: general!, feature: state.feature),
          );
        };
        switch (state.feature.type) {
          case FeatureType.attendanceClockingIn:
            showRequiredAttendanceIn(() => action.call());
            break;
          default:
            showRequiredFeature(state.feature.name!, () => action.call());
        }
      }
      if (state is NecessaryLockOut) {
        showRequiredTask(
          feature: state.feature,
          features: state.features,
          onPressed: () {
            Modular.to.pushNamedAndRemoveUntil(HomeModule.route, (p0) => false);
          },
        );
      }
      if (state is NecessaryUnfastenIn) {
        Modular.to.pushNamed('/${state.feature.type!.name}/',
            arguments:
                GeneralFeatureData(general: general!, feature: state.feature));
      }

      if (state is NecessaryTask) {
        showRequiredTask(
          features: state.features,
          onPressed: () {
            state.onClose();
            Modular.to.pushNamedAndRemoveUntil(HomeModule.route, (p0) => false);
          },
        );
      }
      if (state is NecessaryInternet) {
        showInternetFailure();
      }
      if (state is NecessarySync) {
        showRequiredSync(() {
          state.onClose();
          Modular.to.pushNamed(SyncModule.route);
        }, state.feature);
      }
      if (state is NecessaryAttendanceOut) {
        showRequiredAttendanceOut(() {
          Modular.to.pushNamed('/${state.feature.type!.name}/',
              arguments: GeneralFeatureData(
                  general: general!, feature: state.feature));
        });
      }
      if (state is NecessaryFaceVerified) {
        showRequiredFaceVerified(
          onPressed: () {
            Modular.to.pushNamed(ProfileModule.route,
                arguments: general!.project.id!);
          },
        );
      }
      if (state is NecessaryUnfastenOut) {
        state.action();
      }
    });
  }

  final ScheduleService scheduleService = ScheduleService();

  Future<void> onNecessaryIn(
      NecessaryIn event, Emitter<NecessaryState> emit) async {
    final _connectivityService = Modular.get<ConnectivityService>();

    if (event.feature.type!.isOnline) {
      final hasNoSynced = _syncBloc.state.status == SyncStatus.isNoSynced;
      if (hasNoSynced) {
        emit(NecessarySync(
            onClose: () {},
            feature: 'xem ' + event.feature.name!.toLowerCase()));
        return;
      }
      if (!_connectivityService.hasConnected) {
        emit(NecessaryInternet());
        return;
      }
    }
    final isOrderOnline =
        event.feature.type == FeatureType.customerInformationCapturing &&
            event.feature.isImmediateSendRequired == true;
    if (isOrderOnline && !_connectivityService.hasConnected) {
      emit(NecessaryInternet());
      return;
    }
    bool _isLock = false;

    event.feature.dependentOnFeatureIds?.forEach((dependent) {
      final feature = general!.config.features!
          .firstWhereOrNull((feature) => feature.id == dependent);
      if (feature != null) {
        switch (feature.type) {
          case FeatureType.attendanceClockingIn:
            if (general!.attendance == null ||
                general!.attendance!.dataOut != null) {
              emit(NecessaryLockIn(feature: feature));
              _isLock = true;
              break;
            }
          default:
        }
      }
    });

    if (!_isLock &&
        event.feature.featureAttendance != null &&
        event.feature.featureAttendance!.isFaceRequired! &&
        !(user!.isFaceVerified ?? false)) {
      emit(NecessaryFaceVerified(feature: event.feature));
      _isLock = true;
    }
    if (!_isLock) {
      emit(NecessaryUnfastenIn(feature: event.feature));
    }
  }

  Future<void> onNecessaryOut(NecessaryOut event, emit) async {
    final features =
        await checkTasksNotCompleted(feature: event.feature, general: general!);

    final tasks = features.where((element) =>
        element.type != FeatureType.attendanceClockingOut &&
        element.type != FeatureType.synchronization);

    if (tasks.isNotEmpty) {
      features.removeWhere((element) =>
          element.type == FeatureType.attendanceClockingOut ||
          element.type == FeatureType.synchronization);
      emit(NecessaryLockOut(features: features, feature: event.feature));
      return;
    }

    ///check sync
    final featureSync = features.firstWhereOrNull(
        (element) => element.type == FeatureType.synchronization);

    if (featureSync != null) {
      emit(NecessarySync(
          onClose: () {}, feature: event.feature.name!.toLowerCase()));
      return;
    }

    if (features.isEmpty) {
      emit(NecessaryUnfastenOut(action: event.action));
    }
  }

  Future<void> onNecessarySignOut(NecessarySignOut event, emit) async {
    // final features = await checkTasksNotCompleted(general: general);

    // if (features.isEmpty) {
    //   emit(NecessaryUnfastenOut(action: event.action));
    //   return;
    // }

    // ///  check tasks
    // final tasks = features.where((feature) =>
    //     feature.type != FeatureType.attendanceClockingOut &&
    //     feature.type != FeatureType.synchronization);

    // if (tasks.isNotEmpty) {
    //   features.removeWhere((element) =>
    //       element.type == FeatureType.attendanceClockingOut ||
    //       element.type == FeatureType.synchronization);

    //   emit(NecessaryTask(onClose: event.onClose, features: features));
    //   return;
    // }

    ///check sync
    final featureSync = general!.config.features!.firstWhereOrNull(
        (element) => element.type == FeatureType.synchronization);

    if (featureSync != null &&
        _syncBloc.state.status == SyncStatus.isNoSynced) {
      emit(NecessarySync(onClose: event.onClose, feature: event.functionName));
      return;
    }

    emit(NecessaryUnfastenOut(action: event.action));

    // /// check attendance out
    // final featureAttendanceOut = features.firstWhereOrNull(
    //     (feature) => feature.type == FeatureType.attendanceClockingOut);
    // if (featureAttendanceOut != null) {
    //   emit(NecessaryAttendanceOut(feature: featureAttendanceOut));
    //   return;
    // }
  }

  Future<List<FeatureEntity>> checkTasksNotCompleted(
      {required GeneralEntity general, FeatureEntity? feature}) async {
    final List<FeatureEntity> features = [];
    final List<int> dependentOnFeatureIds = [];
    if (feature == null) {
      dependentOnFeatureIds.addAll(general.config.features
              ?.where((feature) => !feature.type!.isAssistance)
              .map((e) => e.id!) ??
          []);
    } else {
      dependentOnFeatureIds.addAll(feature.dependentOnFeatureIds ?? []);
    }
    await Future.forEach(dependentOnFeatureIds, (dependent) async {
      final dependentFeature = general.config.features!
          .firstWhereOrNull((feature) => feature.id == dependent);
      if (dependentFeature != null) {
        if ((dependentFeature.schedules ?? []).isNotEmpty &&
            await scheduleService.checkSchedules(dependentFeature.schedules!) ==
                false) {
          return;
        }

        if (dependentFeature.type == FeatureType.photography) {
          await getPhotosNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(data);
              }
            });
        }
        if (dependentFeature.type ==
            FeatureType.multiSubjectMultimediaInformationCapturing) {
          await getNotesNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(data);
              }
            });
        }
        if (dependentFeature.type ==
            FeatureType.multipleEntitiesQuantityCapturing) {
          await getQuantitiesNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(data);
              }
            });
        }
        if (dependentFeature.type == FeatureType.sampling) {
          await getSamplingsNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(data);
              }
            });
        }

        if (dependentFeature.type == FeatureType.synchronization) {
          final hasSynced = _syncBloc.state.status == SyncStatus.isNoSynced;
          if (hasSynced) {
            features.add(dependentFeature);
          }
        }
        if (dependentFeature.type == FeatureType.attendanceClockingOut) {
          if (general.attendance != null &&
              general.attendance!.dataOut == null) {
            features.add(dependentFeature);
          }
        }
        if (dependentFeature.type == FeatureType.urgency) {
          await getCurrentUrgencyUsecase(dependentFeature.id!)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(dependentFeature);
              }
            });
        }
        if (dependentFeature.type == FeatureType.numericSheet) {
          await getGenericDataNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(dependentFeature);
              }
            });
        }
        if (dependentFeature.type == FeatureType.outOfStockStatus) {
          await getOosNotCompleted(dependentFeature)
            ..fold((failure) {}, (data) {
              if (data != null) {
                features.add(dependentFeature);
              }
            });
        }
      }
    });
    return features;
  }

  // Future<bool> checkHasNoSynced({required GeneralEntity general}) async {
  //   bool hasNoSynced = false;
  //   final List<int> featureIds = general.config.features
  //           ?.where((feature) => !feature.type!.isAssistance)
  //           .map((e) => e.id!)
  //           .toList() ??
  //       [];

  //   await Future.forEach(featureIds, (dependent) async {
  //     final dependentFeature = general.config.features!
  //         .firstWhereOrNull((feature) => feature.id == dependent);
  //     if (dependentFeature != null) {
  //       if (dependentFeature.type == FeatureType.photography) {
  //         await hasPhotosNoSynced(general)
  //           ..fold((failure) {}, (data) {
  //             if (data.isNotEmpty) {
  //               hasNoSynced = true;
  //             }
  //           });
  //       }
  //     }
  //     if (hasNoSynced) return hasNoSynced;
  //   });
  //   return hasNoSynced;
  // }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
