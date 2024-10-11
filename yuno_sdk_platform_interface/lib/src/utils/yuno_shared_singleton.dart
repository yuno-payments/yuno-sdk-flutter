/// // Set a value
/// YunoSharedSingleton.setValue('greeting', 'Hello, World!');
///
/// // Get a value
/// String value = YunoSharedSingleton.getValue('greeting');
/// ```
class YunoSharedSingleton {
  /// Private constructor to prevent external instantiation.
  YunoSharedSingleton._privateConstructor();

  /// The single instance of the class.
  static final YunoSharedSingleton _instance =
      YunoSharedSingleton._privateConstructor();

  /// Getter to access the singleton instance.
  static YunoSharedSingleton get instance => _instance;

  /// Map to store shared key-value pairs.
  static final Map<String, dynamic> _sharedData = {};

  /// Sets a value in the shared data map.
  ///
  /// [key] is the unique identifier for the value.
  /// [value] is the data to be stored, which can be of any type.
  static void setValue(String key, dynamic value) {
    _sharedData[key] = value;
  }

  /// Retrieves a value from the shared data map.
  ///
  /// [key] is the unique identifier for the value.
  /// Returns the value associated with the [key], or `null` if the key does not exist.
  static dynamic getValue(String key) {
    return _sharedData[key];
  }
}

enum KeysSingleton {
  /// The key for the countryCode.
  countryCode,
}
