import 'package:flutter_flavor/flutter_flavor.dart';
import '/core/constant/keys.dart';

FlavorConfig get env => FlavorConfig.instance;

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal() {
    _initializeConfig();
  }

  static const _appName = String.fromEnvironment(Keys.APP_NAME);
  static const _env = String.fromEnvironment(Keys.ENV);
  static const _baseURL = String.fromEnvironment(Keys.BASE_URL);
  static const _authDomain = String.fromEnvironment(Keys.AUTH0_DOMAIN);
  static const _authScheme = String.fromEnvironment(Keys.AUTH0_CUSTOM_SCHEME);
  static const _authClientId = String.fromEnvironment(Keys.AUTH0_CLIENT_ID);
  static const _audience = String.fromEnvironment(Keys.AUDIENCE);
  static const _lucky = String.fromEnvironment(Keys.LUCKY);

  Map<String, String> variables = {
    Keys.APP_NAME: _appName,
    Keys.BASE_URL: _baseURL,
    Keys.AUTH0_CLIENT_ID: _authClientId,
    Keys.AUTH0_CUSTOM_SCHEME: _authScheme,
    Keys.AUTH0_DOMAIN: _authDomain,
    Keys.AUDIENCE: _audience,
    Keys.LUCKY: _lucky,
    Keys.ENV: _env,
  };

  void _initializeConfig() {
    FlavorConfig(name: _env, variables: variables);
  }
}
