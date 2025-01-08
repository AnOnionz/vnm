import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/firebase/firebase_remote_config_service.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:vnm/features/setting/presentation/widgets/setting_item.dart';
import 'package:vnm/features/setting/setting_module.dart';

import '../../../../core/database/database.dart';
import '../../domain/entities/setting_app.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingCubit cubit = Modular.get<SettingCubit>();

  final _remoteConfig = FirebaseRemoteConfigService();

  late bool canSaveGallery = _remoteConfig.saveToGallery;

  @override
  void initState() {
    super.initState();
    _remoteConfig.onConfigUpdated.listen((event) async {
      await _remoteConfig.fetchAndActivate();

      if (mounted) {
        setState(() {
          canSaveGallery = _remoteConfig.saveToGallery;
        });
      }
      final setting = Database.instance.getObject<SettingApp>();
      if (setting != null && _remoteConfig.saveToGallery == false) {
        Database.instance
            .addObject<SettingApp>(setting.copyWith(saveGallery: false));
      }
    });
  }

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Cài đặt'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h),
        child: BlocBuilder<SettingCubit, SettingState>(
          bloc: cubit,
          builder: (_, state) {
            return Column(
              children: [
                SettingItem(
                    icon: SvgPicture.asset(AppIcons.cameraOrange),
                    name: 'Camera dự phòng',
                    type: SettingType.toggle,
                    switchValue: state.settings.useCameraZ,
                    onTap: () {
                      cubit.cameraToggle();
                    }),
                // SettingItem(
                //     icon: SvgPicture.asset(AppIcons.fingerprint),
                //     name: 'Khóa app',
                //     type: SettingType.transfer,
                //     onTap: () => context.nextRoute(SettingModule.appLock)),
                SettingItem(
                    icon: SvgPicture.asset(AppIcons.lock),
                    name: 'Đổi mật khẩu tài khoản',
                    type: SettingType.transfer,
                    onTap: () => context.nextRoute(SettingModule.changePass)),
                SettingItem(
                    icon: SvgPicture.asset(AppIcons.trash),
                    name: 'Xóa data app',
                    type: SettingType.none,
                    onTap: () {
                      cubit.deteleAppData();
                    }),
                if (canSaveGallery)
                  SettingItem(
                      icon: SvgPicture.asset(AppIcons.image24,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                              AppColors.primary, BlendMode.srcIn)),
                      name: 'Tự động lưu hình về thiết bị',
                      type: SettingType.toggle,
                      switchValue: state.settings.saveGallery ?? false,
                      onTap: () {
                        cubit.saveGalleryToggle();
                      })
              ],
            );
          },
        ),
      ),
    );
  }
}
