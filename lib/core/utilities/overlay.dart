import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';

import '/core/widgets/loading_alert.dart';
import '../constant/colors.dart';
import '../constant/enum.dart';
import '../widgets/custom_bottom_sheet.dart';

final class OverlayManager {
  static BuildContext? get currentContext =>
      Modular.routerDelegate.navigatorKey.currentContext;

  OverlayManager._();

  static Map<String, OverlayEntry> _overlays = {};

  static void hideDialog() => Modular.to.pop();

  static void remove({required String key}) {
    if (_overlays[key] != null && _overlays[key]!.mounted) {
      _overlays[key]!.remove();
      _overlays.remove(key);
    }
  }

  static Future<void> showLoading({String? message}) async {
    await showAppDialog(
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: LoadingAlert(
          message: message ?? 'Vui lòng đợi...',
        ),
      ),
    );
  }

  static dynamic showSheet({required Widget body}) async {
    return showModalBottomSheet(
        context: currentContext!,
        isScrollControlled: true,
        elevation: 2.0,
        constraints: BoxConstraints(
            maxHeight: currentContext!.screenHeight -
                currentContext!.screenPadding.top -
                68.h),
        builder: (context) {
          return CustomBottomSheet(
            child: body,
          );
        });
  }

  static Future<void> showAppDialog(
      {required WidgetBuilder builder, bool barrierDismissible = true}) async {
    await showDialog(
      context: currentContext!,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  static Future<void> showServiceDialog({
    String? title,
    String? message,
    VoidCallback? solution,
  }) async {
    await showAppDialog(
      barrierDismissible: false,
      builder: (context) => ServiceDialog(
        title: title,
        message: message,
        onSolution: solution,
        onClose: () => hideDialog(),
      ),
    );
  }

  static Future<void> showSnackbar({required SnackBar snackbar}) async {
    ScaffoldMessenger.of(currentContext!).clearSnackBars();
    ScaffoldMessenger.of(currentContext!).showSnackBar(snackbar);
  }

  static void showDefaultToast(
      {String? key,
      required String msg,
      required String title,
      required Widget icon,
      ToastGravity? gravity = ToastGravity.bottom,
      bool isDismissable = true,
      bool isDraggable = false,
      Duration? duration}) {
    double? top;
    double? bottom;
    final pb = currentContext?.screenPadding.bottom ?? 0;
    final pt = currentContext?.screenPadding.top ?? 0;

    if (gravity == ToastGravity.top) {
      top = pt;
    }
    if (gravity == ToastGravity.bottom) {
      bottom = pb + 10.w;
    }

    _showToast(
        toastKey: key,
        top: top,
        bottom: bottom,
        left: 16.w,
        right: 16.w,
        isDismissable: isDismissable,
        isDraggable: isDraggable,
        toastDuration: duration ?? 2.seconds,
        builder: (onDismiss) => CustomToast(
              title: title,
              icon: icon,
              message: msg,
              onDismiss: onDismiss,
            ));
  }

  static Future<void> _showToast({
    String? toastKey,
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Widget Function(VoidCallback? onDissmiss) builder,
    Duration toastDuration = const Duration(seconds: 2),
    Duration fadeDuration = const Duration(milliseconds: 350),
    bool ignorePointer = false,
    bool isDismissable = false,
    bool isDraggable = false,
  }) async {
    OverlayEntry? overlayEntry;

    Timer? _timer;
    Timer? _fadeTimer;

    if (_overlays.containsKey(toastKey)) return;

    void onClose() {
      _timer?.cancel();
      _fadeTimer?.cancel();
      _timer = null;
      _fadeTimer = null;
      _overlays.remove(toastKey);
      overlayEntry?.remove();
    }

    final onDismiss = isDismissable ? () => onClose() : null;

    overlayEntry = OverlayEntry(
        maintainState: true,
        builder: (context) => _OverlayEntry(
            child: builder(onDismiss),
            bottom: bottom,
            left: left,
            right: right,
            top: top,
            duration: toastDuration,
            fadeDuration: fadeDuration,
            ignorePointer: ignorePointer,
            onDismiss: onDismiss,
            isDraggable: isDraggable));

    Overlay.of(currentContext!).insert(overlayEntry);

    if (toastKey != null && _overlays[toastKey] == null) {
      _overlays[toastKey] = overlayEntry;
    }

    _timer = Timer(toastDuration, () {
      _fadeTimer = Timer(fadeDuration, onClose);
    });
  }

  static Future<void> showSimpleToast(
      {Widget? content,
      String? msg,
      Color? background,
      required BuildContext context}) async {
    assert(msg != null || content != null);
    final bottom = context.screenPadding.bottom;
    _showToast(
        toastDuration: 2.seconds,
        bottom: 10.w + bottom,
        left: 16.w,
        right: 16.w,
        builder: (onDismiss) =>
            content ??
            Container(
              width: context.screenWidth - 32.w,
              padding: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 20.w),
              decoration: BoxDecoration(
                color: background ?? AppColors.delRio,
                borderRadius: BorderRadius.circular(12.sqr),
              ),
              child: Center(
                  child: Text(msg ?? '', style: context.textTheme.body2)),
            ));
  }
}

class _OverlayEntry extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration fadeDuration;
  final bool ignorePointer;
  final bool isDraggable;
  final VoidCallback? onDismiss;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _OverlayEntry({
    required this.child,
    required this.duration,
    required this.fadeDuration,
    required this.ignorePointer,
    required this.isDraggable,
    this.onDismiss,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  State<_OverlayEntry> createState() => _OverlayEntryState();
}

class _OverlayEntryState extends State<_OverlayEntry>
    with SingleTickerProviderStateMixin {
  late double? top = widget.top;
  late double? bottom = widget.bottom;
  late double? left = widget.left;
  late double? right = widget.right;
  final GlobalKey _key = GlobalKey();

  void showIt() {
    _animationController!.forward();
  }

  /// Start the hidding animations for the toast
  void hideIt() {
    _animationController!.reverse();
    _timer?.cancel();
  }

  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late Animation<double> _fadeAnimation;

  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    super.initState();

    showIt();
    _timer = Timer(widget.duration, () {
      hideIt();
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _animationController!.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entry = IgnorePointer(
      key: _key,
      ignoring: widget.ignorePointer,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      top: top,
      child: Draggable(
        feedback: entry,
        axis: Axis.vertical,
        maxSimultaneousDrags: widget.isDraggable ? 1 : 0,
        onDragEnd: (details) {
          final RenderBox? box =
              _key.currentContext?.findRenderObject() as RenderBox?;
          final maxTop = context.screenHeight -
              (box?.size.height ?? 0) -
              context.screenPadding.bottom;
          final minTop = (box?.size.height ?? 0) + context.viewInsets.top;
          left = details.offset.dx;
          top = details.offset.dy;
          bottom = null;
          right = null;

          if (details.offset.dy > maxTop) top = maxTop;
          if (details.offset.dy < minTop) top = minTop;

          setState(() {});
        },
        childWhenDragging: SizedBox.shrink(),
        child: GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: entry,
        ),
      ),
    );
  }
}

class CustomToast extends StatelessWidget {
  final String title;
  final String message;
  final Widget icon;
  final VoidCallback? onDismiss;
  const CustomToast(
      {super.key,
      required this.title,
      required this.message,
      required this.icon,
      this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth - 32.w,
      padding: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sqr),
        border: Border.all(color: 'F4B0A1'.toColor()),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 16,
              color: '100B27'.toColor(0.08))
        ],
        color: 'FFF5F3'.toColor(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onDismiss != null)
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: onDismiss,
                    child: SvgPicture.asset(AppIcons.closeToast))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: context.textTheme.h3
                            ?.copyWith(color: '27303A'.toColor())),
                    SizedBox(height: 4.h),
                    Text(message,
                        style: context.textTheme.body1
                            ?.copyWith(color: '2F3F53'.toColor())),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ServiceDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onSolution;
  final VoidCallback onClose;
  const ServiceDialog(
      {super.key,
      this.title,
      this.message,
      required this.onSolution,
      required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: message != null ? Text(message!) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      contentTextStyle:
          context.textTheme.subtitle1?.copyWith(color: AppColors.black),
      titleTextStyle: context.textTheme.h2?.copyWith(color: AppColors.black),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titlePadding: EdgeInsets.only(top: 24, bottom: 8, left: 16, right: 16),
      actionsPadding: EdgeInsets.only(bottom: 16),
      backgroundColor: AppColors.white,
      actions: [
        ...[
          TextButton(
              onPressed: onClose,
              child: Text(
                'Đóng',
                style: context.textTheme.caption1
                    ?.copyWith(color: AppColors.black),
              ))
        ],
        ...onSolution != null
            ? [
                TextButton(
                    onPressed: () {
                      onClose();
                      onSolution?.call();
                    },
                    child: Text(
                      'Mở cài đặt',
                      style: context.textTheme.caption1
                          ?.copyWith(color: AppColors.royalBlue),
                    ))
              ]
            : [],
      ],
    );
  }
}
