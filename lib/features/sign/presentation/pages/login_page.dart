import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/constant/images.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/widgets/button/flat.dart';
import 'package:fms/features/sign/presentation/bloc/sign_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = Modular.get<SignBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(AppImages.logo);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 20.w, left: 48.w, right: 48.w),
            child: SvgPicture.asset(
              AppImages.logo,
              // height: 288,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Image.asset(
              AppImages.loginBanner,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(27.w, 44.h, 27.w, 27.w),
            child: SizedBox(
                width: context.screenSize.width,
                child: FlatButton(
                    onPressed: () async => _bloc.add(SignInButtonPressed()),
                    name: context.language.loginButtonText,
                    color: AppColors.primary)),
          ),
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: 15.w),
          //     child: Text('Powered by Outcome.asia',
          //         style: context.textTheme.caption1
          //             ?.copyWith(color: AppColors.nobel)),
          //   ),
          // ),
        ],
      ),
    ));
  }
}
