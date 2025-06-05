class DbConfigurationsByDev {
  static final DbConfigurationsByDev _singleton =
      DbConfigurationsByDev._internal();

  factory DbConfigurationsByDev() {
    return _singleton;
  }

  DbConfigurationsByDev._internal();

  /// Store's the data only it is Offline
  static bool storeOnlyIfOffline = false;

  /// if any one of the property is true it will store the data
  /// in local database
  static bool get storeData => storeOnlyIfOffline;
}
