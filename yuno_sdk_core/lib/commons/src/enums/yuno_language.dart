/// Enum representing the languages supported by the Yuno SDK.
/// Example usage:
///
/// ```dart
/// void main() {
///   // Get the language code for Spanish
///   YunoLanguage language = YunoLanguage.es;
///   print('Selected language: ${language.rawValue}');
///
///   // Switch on the language
///   switch (language) {
///     case YunoLanguage.en:
///       print('English selected');
///       break;
///     case YunoLanguage.es:
///       print('Spanish selected');
///       break;
///     // Handle other languages...
///     default:
///       print('Other language selected');
///   }
/// }
/// ```
///
/// The output will be:
/// ```
/// Selected language: ES
/// Spanish selected
/// ```
enum YunoLanguage {
  /// English language.
  en('EN'),

  /// Spanish language.
  es('ES'),

  /// Portuguese language.
  pt('PT'),

  /// Malay language.
  ms('MW'),

  /// Indonesian language.
  id('ID'),

  /// Thai language.
  th('TH');

  /// The raw value of the language code.
  final String rawValue;

  /// Constructor for creating an instance of [YunoLanguage].
  ///
  /// Takes a language code as [rawValue].
  const YunoLanguage(this.rawValue);
}
