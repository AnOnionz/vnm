import 'package:flutter/widgets.dart';
import 'package:vnm/core/constant/keys.dart';
import 'package:vnm/core/environment/env.dart';
import 'package:share_plus/share_plus.dart'
    show Share, ShareResult, ShareResultStatus, XFile;

class ShareUtils {
  static Future<ShareResult> ShareXFiles(BuildContext context,
      {required List<XFile> files}) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      final shareResult = await Share.shareXFiles(
        files,
        subject: env.variables[Keys.APP_NAME] as String,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      return shareResult;
    } catch (e) {
      return ShareResult('', ShareResultStatus.unavailable);
    }
  }
}
