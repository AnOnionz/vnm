import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:fms/core/widgets/app_indicator.dart';

import '../bloc/lock_bloc.dart';

class LockScreenCreatePage extends StatefulWidget {
  const LockScreenCreatePage({super.key});

  @override
  State<LockScreenCreatePage> createState() => _LockScreenCreatePageState();
}

class _LockScreenCreatePageState extends State<LockScreenCreatePage> {
  final lockBloc = Modular.get<AppLockBloc>();

  @override
  void initState() {
    super.initState();
    if (lockBloc.state is! AppLockSuccess) {
      lockBloc.add(const AppLockStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<AppLockBloc, AppLockState>(
        bloc: lockBloc,
        listener: (context, state) {
          if (state is AppLockSuccess && state.isSaved) {
            Modular.to.pop();
          }
        },
        builder: (context, state) {
          if (state is AppLockLoading) {
            return Center(
              child: AppIndicator(),
            );
          }
          return ScreenLock.create(
            config: ScreenLockConfig.defaultConfig,
            onConfirmed: (value) {
              lockBloc.add(AppLockPasscodeSaved(value));
            },
            onCancelled: () {
              Modular.to.pop();
            },
          );
        },
      ),
    );
  }
}
