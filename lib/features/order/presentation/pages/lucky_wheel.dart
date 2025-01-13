import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/client/dio_client.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/constant/keys.dart';
import 'package:fms/core/environment/env.dart';
import 'package:fms/core/mixins/extension/context_ext.dart';
import 'package:fms/core/mixins/extension/string_ext.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/widgets/app_bar.dart';
import 'package:fms/core/widgets/app_indicator.dart';
import 'package:fms/core/widgets/notifications.dart';
import 'package:fms/features/home/domain/entities/general_item_data.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';
import 'package:fms/features/order/lucky_wheel_module.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LuckyWheelPage extends StatefulWidget {
  final GeneralFeatureData generalFeature;
  final OrderEntity order;
  final bool isEditing;
  const LuckyWheelPage(
      {super.key,
      required this.generalFeature,
      required this.order,
      this.isEditing = false});

  @override
  State<LuckyWheelPage> createState() => _LuckyWheelPageState();
}

class _LuckyWheelPageState extends State<LuckyWheelPage> {
  final DioClient _client = Modular.get();
  double progressLoading = 0.0;
  bool pageLoaded = false;
  bool pageReLoad = false;

  final controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              progressLoading = progress / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print(321321313);
            setState(() {
              pageLoaded = true;
              pageReLoad = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (change) {
            if ((change.url ?? '').contains('exit')) {
              context.nextReplacementRoute(LuckyWheelModule.summary,
                  arguments: [
                    widget.generalFeature,
                    widget.order,
                    widget.isEditing
                  ]);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          '${env.variables[Keys.LUCKY] as String}/lucky?token=${_client.token?.replaceAll('Bearer ', '')}&orderId=${widget.order.id}&attendanceId=${widget.generalFeature.general.attendance!.id}'));

    controller.addJavaScriptChannel('onMessageReceived',
        onMessageReceived: (message) {
      print('onMessageReceived : ${message.message}');
    });
  }

  @override
  void dispose() {
    controller.removeJavaScriptChannel('onMessageReceived');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: pageLoaded ? '#C01D2E'.toColor() : null,
        appBar: DefaultAppBar(
          title: '',
          iconBack: SvgPicture.asset(
            AppIcons.closeRegular,
            height: 13.w,
            colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          ),
          action: pageReLoad
              ? null
              : InkWell(
                  onTap: () async {
                    setState(() {
                      pageReLoad = true;
                    });
                    await controller.reload();
                    setState(() {
                      pageReLoad = false;
                    });
                  },
                  splashColor: Colors.transparent,
                  overlayColor: WidgetStatePropertyAll(AppColors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      'Làm mới',
                      style: context.textTheme.h3
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
          onBack: pageLoaded
              ? () {
                  showLuckyWheelCancel(
                      onPressed: () => context.nextReplacementRoute(
                              LuckyWheelModule.summary,
                              arguments: [
                                widget.generalFeature,
                                widget.order,
                                widget.isEditing
                              ]));
                }
              : null,
        ),
        body: Stack(
          children: [
            if (!(pageLoaded && !pageReLoad))
              Align(
                child: AppIndicator(
                  height: 42,
                  width: 42,
                ),
              ),
            WebViewWidget(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
