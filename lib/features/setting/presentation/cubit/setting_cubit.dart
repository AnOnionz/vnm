import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/cache_image_network/cache_image_manager.dart';
import 'package:vnm/core/database/database.dart';
import 'package:vnm/core/mixins/extension/date_time_ext.dart';
import 'package:vnm/core/services/media/media_service.dart';
import 'package:vnm/features/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:vnm/features/general/domain/entities/general_entity.dart';
import 'package:vnm/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:vnm/features/oos/domain/entities/oos_entity.dart';
import 'package:vnm/features/setting/domain/entities/setting_app.dart';
import 'package:vnm/features/statistic/domain/entities/employee_entity.dart';

import '../../../crawl/domain/entities/crawl_quantity_entity.dart';
import '../../../note/domain/entities/note_entity.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../report/domain/entities/photo_entity.dart';
import '../../../sampling/domain/entities/sampling_entity.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final AuthenticationBloc _authenticationBloc;
  SettingCubit(this._authenticationBloc) : super(SettingState.initial());

  void cameraToggle() {
    emit(state.cameraToggle());
  }

  void saveGalleryToggle() {
    emit(state.saveGalleryToggle());
  }

  void deteleAppData() {
    emit(state.deteleDataApp());
    _authenticationBloc.add(AuthenticationLogout());
  }
}
