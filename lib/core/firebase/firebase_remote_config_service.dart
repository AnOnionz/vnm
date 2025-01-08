import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static FirebaseRemoteConfigService? _instance; // NEW
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._(); // NEW

  final FirebaseRemoteConfig _remoteConfig;

  Stream<RemoteConfigUpdate> get onConfigUpdated =>
      _remoteConfig.onConfigUpdated;

  Future<void> initialize() async {
    await _setConfigSettings();
    // await _setDefaults();
    await fetchAndActivate();
  }

  String getString(String key) => _remoteConfig.getString(key); // NEW
  bool getBool(String key) => _remoteConfig.getBool(key); // NEW
  int getInt(String key) => _remoteConfig.getInt(key); // NEW
  double getDouble(String key) => _remoteConfig.getDouble(key); // NEW

  bool get saveToGallery =>
      FirebaseRemoteConfig.instance.getBool('saveToGallery'); // NEW

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 2),
        ),
      );

  // Future<void> _setDefaults() async => _remoteConfig.setDefaults(
  //       const {
  //         'saveToGallery': false,
  //       },
  //     );

  Future<void> fetchAndActivate() async {
    try {
      final bool updated = await _remoteConfig.fetchAndActivate();

      if (updated) {
        debugPrint('The config has been updated.');
      } else {
        debugPrint('The config is not updated..');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
