import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheImageMagager {
  static void clearCache() {
    try {
      DefaultCacheManager().emptyCache();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<File> getFile(String url) async {
    return await DefaultCacheManager().getSingleFile(url);
  }
}
