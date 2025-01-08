part of 'lock_bloc.dart';

sealed class AppLockEvent extends Equatable {
  const AppLockEvent();
  @override
  List<Object> get props => [];
}

final class AppLockStarted extends AppLockEvent {
  const AppLockStarted();
}

final class AppLockPasscodeDeleted extends AppLockEvent {
  const AppLockPasscodeDeleted();
}

final class AppLockPasscodeSaved extends AppLockEvent {
  final String passcode;
  const AppLockPasscodeSaved(this.passcode);
  @override
  List<Object> get props => [passcode];
}
