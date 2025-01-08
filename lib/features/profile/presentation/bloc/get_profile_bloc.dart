import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vnm/core/errors/failure.dart';
import 'package:vnm/features/profile/domain/entities/user_profile_entity.dart';
import 'package:vnm/features/profile/domain/usecases/get_user_profile_usecase.dart';

part 'get_profile_event.dart';
part 'get_profile_state.dart';

class GetProfileBloc extends Bloc<GetProfileEvent, GetProfileState> {
  final GetUserProfileUsecase _getUserProfile;
  GetProfileBloc(this._getUserProfile) : super(GetProfileInitial()) {
    on<GetProfile>((event, emit) async {
      emit(GetProfileLoading());
      await _getUserProfile()
        ..fold((failure) => emit(GetProfileFailure(failure)),
            (data) => emit(GetProfileSuccess(profile: data)));
    });
  }
}
