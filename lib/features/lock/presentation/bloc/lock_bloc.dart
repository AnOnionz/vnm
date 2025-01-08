import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/usecases/delete_passcode_usecase.dart';
import '../../domain/usecases/has_passcode_usecase.dart';
import '../../domain/usecases/save_passcode_usecase.dart';
import '../../domain/usecases/validate_passcode_usecase.dart';

part 'lock_event.dart';
part 'lock_state.dart';

class AppLockBloc extends Bloc<AppLockEvent, AppLockState> {
  final ValidatePasscodeUsecase validatePasscodeUsecase;
  final HasPasscodeUsecase hasPasscodeUsecase;
  final SavePasscodeUsecase savePasscodeUsecase;
  final DeletePasscodeUsecase deletePasscodeUsecase;

  final _auth = LocalAuthentication();

  AppLockBloc({
    required this.validatePasscodeUsecase,
    required this.hasPasscodeUsecase,
    required this.savePasscodeUsecase,
    required this.deletePasscodeUsecase,
  }) : super(const AppLockInitial()) {
    on<AppLockStarted>(_onLockStarted);
    on<AppLockPasscodeDeleted>(_onLockPasscodeDeleted);
    on<AppLockPasscodeSaved>(_onLockPasscodeSaved);
  }

  Future<void> _onLockStarted(
      AppLockStarted event, Emitter<AppLockState> emit) async {
    emit(const AppLockLoading());

    final hasPasscode = await hasPasscodeUsecase();
    hasPasscode.fold(
        (fail) async => emit(const AppLockFailure()), (success) async => null);

    final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

    final availableBiometrics = await _auth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {}

    emit(
      AppLockSuccess(
        // validatePasscode: validatePasscodeUsecase.call,
        validatePasscode: (value) async => true,
        canAuthenticateWithBiometrics: canAuthenticateWithBiometrics,
        authenticate: canAuthenticate
            ? () async {
                return await _auth.authenticate(
                  localizedReason: 'Please authenticate to open the app',
                  options: const AuthenticationOptions(biometricOnly: true),
                );
              }
            : null,
      ),
    );
  }

  Future<void> _onLockPasscodeDeleted(
    AppLockPasscodeDeleted event,
    Emitter<AppLockState> emit,
  ) async {
    await deletePasscodeUsecase();
    final currentState = state;
    if (currentState is AppLockSuccess) {
      emit(currentState.copyWith(isSaved: false, isDeleted: true));
    }
  }

  Future<void> _onLockPasscodeSaved(
    AppLockPasscodeSaved event,
    Emitter<AppLockState> emit,
  ) async {
    await savePasscodeUsecase(event.passcode);
    final currentState = state;
    if (currentState is AppLockSuccess) {
      emit(currentState.copyWith(isSaved: true, isDeleted: false));
    }
  }
}
