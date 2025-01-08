part of 'lock_bloc.dart';

typedef ValidatePasscodeCallback = Future<bool> Function(String passcode);
typedef AuthenticateBiometricsCallback = Future<bool> Function();

sealed class AppLockState extends Equatable {
  const AppLockState();
  @override
  List<Object?> get props => [];
}

final class AppLockInitial extends AppLockState {
  const AppLockInitial();
}

final class AppLockLoading extends AppLockState {
  const AppLockLoading();
}

final class AppLockSuccess extends AppLockState {
  final ValidatePasscodeCallback validatePasscode;
  final AuthenticateBiometricsCallback? authenticate;
  final bool canAuthenticateWithBiometrics;
  final bool isSaved;
  final bool isDeleted;

  const AppLockSuccess({
    required this.validatePasscode,
    required this.canAuthenticateWithBiometrics,
    this.isSaved = false,
    this.isDeleted = false,
    this.authenticate,
  });

  AppLockSuccess copyWith({
    ValidatePasscodeCallback? validatePasscode,
    bool? canAuthenticateWithBiometrics,
    bool? isSaved,
    bool? isDeleted,
    AuthenticateBiometricsCallback? authenticate,
  }) {
    return AppLockSuccess(
      validatePasscode: validatePasscode ?? this.validatePasscode,
      canAuthenticateWithBiometrics:
          canAuthenticateWithBiometrics ?? this.canAuthenticateWithBiometrics,
      isSaved: isSaved ?? this.isSaved,
      isDeleted: isDeleted ?? this.isDeleted,
      authenticate: authenticate ?? this.authenticate,
    );
  }

  @override
  List<Object?> get props => [
        validatePasscode,
        canAuthenticateWithBiometrics,
        isSaved,
        isDeleted,
        authenticate,
      ];
}

final class AppLockFailure extends AppLockState {
  const AppLockFailure();
}
