import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/data_source/local_data_source.dart';
import 'package:fms/features/crawl/domain/entities/crawl_quantity_entity.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/general/domain/entities/data_entity.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:fms/features/generic_data/domain/usecases/generic_data_no_%20synced_usecase.dart';
import 'package:fms/features/note/domain/entities/note_entity.dart';
import 'package:fms/features/note/domain/usecases/get_notes_no_synced_usecase.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/domain/usecases/get_orders_no_synced_usecase.dart';
import 'package:fms/features/report/domain/entities/photo_entity.dart';
import 'package:fms/features/report/domain/usecases/photos_no_synced_usecase.dart';
import 'package:fms/features/sampling/domain/entities/sampling_entity.dart';

import '../../../../core/constant/type_def.dart';
import '../../../crawl/domain/usecases/quantities_no_synced_usecase.dart';
import '../../../sampling/domain/usecases/get_samplings_no_synced_usecase.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState>
    with LocalDatasource, GeneralDataMixin {
  final PhotosNoSyncedDataUsecase _photosNoSynced;
  final GetNotesNoSyncedDataUsecase _notesNoSynced;
  final GetQuantitiesNoSyncedDataUsecase _quantitiesNoSynced;
  final GetOrdersNoSyncedDataUsecase _ordersNoSynced;
  final GetSamplingsNoSyncedDataUsecase _samplingsNoSynced;
  final GetGenericDataNoSyncedDataUsecase _genericDataNoSynced;
  // final GetOosNoSyncedDataUsecase _oosNoSynced;
  SyncBloc(
    this._photosNoSynced,
    this._notesNoSynced,
    this._quantitiesNoSynced,
    this._ordersNoSynced,
    this._samplingsNoSynced,
    this._genericDataNoSynced,
    // this._oosNoSynced
  ) : super(SyncState.init()) {
    on<SyncStarted>((event, emit) {
      emit(SyncState.successfully());
      _updatePhotoSync();
      _updateNoteSync();
      _updateQuantitySync();
      _updateOrderSync();
      _updateSamplingSync();
      _updateGenericDataSync();
      // _updateOosSync();
    });
    on<SyncAddListener>((event, emit) {
      _photoSubscription =
          db.colection<PhotoEntity>().watchLazy().listen((event) async {
        _updatePhotoSync();
      });
      _noteSubscription =
          db.colection<NoteEntity>().watchLazy().listen((event) async {
        _updateNoteSync();
      });
      _quantitiesSubscription =
          db.colection<CrawlQuantityEntity>().watchLazy().listen((event) async {
        _updateQuantitySync();
      });
      _genericDataSubscription =
          db.colection<NumericSheetEntity>().watchLazy().listen((event) async {
        _updateGenericDataSync();
      });
      _ordersSubscription =
          db.colection<OrderEntity>().watchLazy().listen((event) async {
        _updateOrderSync();
      });
      _samplingsSubscription =
          db.colection<SamplingEntity>().watchLazy().listen((event) async {
        _updateSamplingSync();
      });
      // _oosSubscription =
      //     db.colection<OOSEntity>().watchLazy().listen((event) async {
      //   _updateOosSync();
      // });
    });

    on<SyncUpdated>(_onSyncDataUpdate, transformer: concurrent());
  }

  Future<void> _updatePhotoSync() async => await fold(_photosNoSynced());

  Future<void> _updateNoteSync() async => await fold(_notesNoSynced());

  Future<void> _updateQuantitySync() async => await fold(_quantitiesNoSynced());

  Future<void> _updateOrderSync() async => await fold(_ordersNoSynced());

  Future<void> _updateSamplingSync() async => await fold(_samplingsNoSynced());

  Future<void> _updateGenericDataSync() async =>
      await fold(_genericDataNoSynced());

  // Future<void> _updateOosSync() async => await fold(_oosNoSynced());

  Future<void> fold(Future<Result<Map<int, List<BaseEntity>>>> future) async {
    await future
      ..fold((failure) => null, (data) {
        data.keys.forEach((id) {
          try {
            final feature = getFeature(id);
            if (feature != null) {
              add(SyncUpdated(feature: feature, data: data[id] ?? []));
            }
          } catch (e) {
            debugPrint('failed');
          }
        });
      });
  }

  FutureOr<void> _onSyncDataUpdate(
      SyncUpdated event, Emitter<SyncState> emit) async {
    final Map<FeatureEntity, List<BaseEntity>> data = Map.from(state.data);
    data[event.feature] = event.data;

    final count = data.values.expand((element) => element).length;

    if (count == 0) {
      emit(SyncState.successfully());
    } else
      emit(SyncState.expectation(data: data, number: count));
  }

  StreamSubscription<void>? _photoSubscription;
  StreamSubscription<void>? _noteSubscription;
  StreamSubscription<void>? _quantitiesSubscription;
  StreamSubscription<void>? _ordersSubscription;
  StreamSubscription<void>? _samplingsSubscription;
  StreamSubscription<void>? _genericDataSubscription;
  StreamSubscription<void>? _oosSubscription;
  @override
  Future<void> close() {
    _photoSubscription?.cancel();
    _noteSubscription?.cancel();
    _quantitiesSubscription?.cancel();
    _ordersSubscription?.cancel();
    _samplingsSubscription?.cancel();
    _genericDataSubscription?.cancel();
    _oosSubscription?.cancel();
    return super.close();
  }
}
