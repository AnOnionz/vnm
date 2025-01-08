part of 'setting_cubit.dart';

class SettingState extends Equatable {
  final SettingApp settings;

  SettingState({required this.settings});

  factory SettingState.initial() {
    final database = Database.instance;
    final settingApp = database.getObject<SettingApp>();
    if (settingApp == null) {
      final s = SettingApp(appLock: AppLock());
      database.addObject<SettingApp>(s);
      return SettingState(settings: s);
    }
    return SettingState(settings: settingApp);
  }

  SettingState cameraToggle() {
    final newSettings = settings.copyWith(cameraCustom: !settings.useCameraZ);
    Database.instance.addObject<SettingApp>(newSettings);
    return copyWith(settings: newSettings);
  }

  SettingState saveGalleryToggle() {
    final MediaService _mediaService = MediaService();
    if (settings.saveGallery != true) {
      _mediaService.requestPhotosPermission();
    }
    final newSettings =
        settings.copyWith(saveGallery: !(settings.saveGallery ?? false));
    Database.instance.addObject<SettingApp>(newSettings);
    return copyWith(settings: newSettings);
  }

  SettingState deteleDataApp() {
    final db = Database.instance;
    CacheImageMagager.clearCache();
    db.clearCollection<GeneralEntity>();
    db.clearCollection<SettingApp>();
    db.clearCollection<EmployeeEntity>();
    db.clearCollection<PhotoEntity>();
    db.clearCollection<NoteEntity>();
    db.clearCollection<CrawlQuantityEntity>();
    db.clearCollection<SamplingEntity>();
    db.clearCollection<OrderEntity>();
    db.clearCollection<NumericSheetEntity>();
    db.clearCollection<OOSEntity>();
    db.setValue(DateTime.now().formatBy(khmdMy), 'deteleDataApp');
    return this;
  }

  @override
  List<Object> get props => [settings];

  SettingState copyWith({
    SettingApp? settings,
  }) {
    return SettingState(
      settings: settings ?? this.settings,
    );
  }
}
