import 'dart:ui';

/// Configuration options specific to iOS for the Yuno SDK.
///
/// Use this class to customize the appearance and behavior of the SDK on iOS.
class IosConfig {
  /// Creates an instance of `IosConfig`.
  ///
  /// Use the `appearance` parameter to customize the UI appearance.
  ///
  /// Example:
  /// ```dart
  /// IosConfig(
  ///   appearance: Appearance(
  ///     fontFamily: 'Helvetica',
  ///     accentColor: Colors.blue,
  ///   ),
  /// );
  /// ```
  const IosConfig({
    this.appearance,
  });

  /// The appearance settings for customizing the UI on iOS.
  ///
  /// This includes options for font, colors, and button styles.
  final Appearance? appearance;

  @override
  bool operator ==(covariant IosConfig other) {
    if (identical(this, other)) return true;

    return other.appearance == appearance;
  }

  @override
  int get hashCode => appearance.hashCode;
}

/// Appearance customization settings for the Yuno SDK on iOS.
///
/// This class allows you to define the look and feel of various UI elements,
/// such as buttons and others, within the SDK. Customize the appearance
/// by setting properties like `fontFamily` and `accentColor`.
class Appearance {
  /// Creates an instance of `Appearance`.
  ///
  /// Customize the UI elements by providing specific colors and font family.
  ///
  /// Example:
  /// ```dart
  /// Appearance(
  ///   fontFamily: 'Avenir',
  ///   accentColor: Colors.red,
  /// );
  /// ```
  const Appearance({
    this.fontFamily,
    this.accentColor,
    this.buttonBackgrounColor,
    this.buttonTitleBackgrounColor,
    this.buttonBorderBackgrounColor,
    this.secondaryButtonBackgrounColor,
    this.secondaryButtonTitleBackgrounColor,
    this.secondaryButtonBorderBackgrounColor,
    this.disableButtonBackgrounColor,
    this.disableButtonTitleBackgrounColor,
    this.checkboxColor,
  });

  /// The font family to be used in the SDK UI.
  ///
  /// Available options include:
  /// - `"Academy Engraved LET"`
  /// - `"Al Nile"`
  /// - `"American Typewriter"`
  /// - `"Apple Color Emoji"`
  /// - `"Arial"`
  /// - `"Avenir"`
  /// - `"Avenir Next"`
  /// - `"Bangla Sangam MN"`
  /// - `"Baskerville"`
  /// - `"Bodoni 72"`
  /// - `"Bodoni 72 Oldstyle"`
  /// - `"Chalkboard SE"`
  /// - `"Chalkduster"`
  /// - `"Courier"`
  /// - `"Courier New"`
  /// - `"DIN Alternate"`
  /// - `"DIN Condensed"`
  /// - `"Didot"`
  /// - `"Euphemia UCAS"`
  /// - `"Farah"`
  /// - `"Futura"`
  /// - `"Geeza Pro"`
  /// - `"Gill Sans"`
  /// - `"Helvetica"`
  /// - `"Helvetica Neue"`
  /// - `"Hiragino Maru Gothic ProN"`
  /// - `"Hiragino Mincho ProN"`
  /// - `"Hoefler Text"`
  /// - `"Kailasa"`
  /// - `"Kannada Sangam MN"`
  /// - `"Kefa"`
  /// - `"Khmer Sangam MN"`
  /// - `"Kohinoor Bangla"`
  /// - `"Kohinoor Devanagari"`
  /// - `"Kohinoor Telugu"`
  /// - `"Lao Sangam MN"`
  /// - `"Malayalam Sangam MN"`
  /// - `"Marion"`
  /// - `"Marker Felt"`
  /// - `"Menlo"`
  /// - `"Mishafi"`
  /// - `"Noteworthy"`
  /// - `"Optima"`
  /// - `"Palatino"`
  /// - `"Party LET"`
  /// - `"PingFang HK"`
  /// - `"PingFang SC"`
  /// - `"PingFang TC"`
  /// - `"Rockwell"`
  /// - `"Savoye LET"`
  /// - `"Sinhala Sangam MN"`
  /// - `"Snell Roundhand"`
  /// - `"Symbol"`
  /// - `"Tahoma"`
  /// - `"Tamil Sangam MN"`
  /// - `"Telugu Sangam MN"`
  /// - `"Thonburi"`
  /// - `"Times New Roman"`
  /// - `"Trebuchet MS"`
  /// - `"Verdana"`
  /// - `"Zapf Dingbats"`
  /// - `"Zapfino"`
  ///
  /// If `null`, the default system font will be used.
  final String? fontFamily;

  /// The accent color used for highlights and active elements in the SDK UI.
  final Color? accentColor;

  /// The background color for primary buttons in the UI.
  final Color? buttonBackgrounColor;

  /// The text color for titles on primary buttons in the UI.
  final Color? buttonTitleBackgrounColor;

  /// The border color for primary buttons in the UI.
  final Color? buttonBorderBackgrounColor;

  /// The background color for secondary buttons in the UI.
  final Color? secondaryButtonBackgrounColor;

  /// The text color for titles on secondary buttons in the UI.
  final Color? secondaryButtonTitleBackgrounColor;

  /// The border color for secondary buttons in the UI.
  final Color? secondaryButtonBorderBackgrounColor;

  /// The background color for disabled buttons in the UI.
  final Color? disableButtonBackgrounColor;

  /// The text color for titles on disabled buttons in the UI.
  final Color? disableButtonTitleBackgrounColor;

  /// The color of checkboxes in the SDK UI.
  final Color? checkboxColor;

  @override
  bool operator ==(covariant Appearance other) {
    if (identical(this, other)) return true;

    return other.fontFamily == fontFamily &&
        other.accentColor == accentColor &&
        other.buttonBackgrounColor == buttonBackgrounColor &&
        other.buttonTitleBackgrounColor == buttonTitleBackgrounColor &&
        other.buttonBorderBackgrounColor == buttonBorderBackgrounColor &&
        other.secondaryButtonBackgrounColor == secondaryButtonBackgrounColor &&
        other.secondaryButtonTitleBackgrounColor ==
            secondaryButtonTitleBackgrounColor &&
        other.secondaryButtonBorderBackgrounColor ==
            secondaryButtonBorderBackgrounColor &&
        other.disableButtonBackgrounColor == disableButtonBackgrounColor &&
        other.disableButtonTitleBackgrounColor ==
            disableButtonTitleBackgrounColor &&
        other.checkboxColor == checkboxColor;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        accentColor.hashCode ^
        buttonBackgrounColor.hashCode ^
        buttonTitleBackgrounColor.hashCode ^
        buttonBorderBackgrounColor.hashCode ^
        secondaryButtonBackgrounColor.hashCode ^
        secondaryButtonTitleBackgrounColor.hashCode ^
        secondaryButtonBorderBackgrounColor.hashCode ^
        disableButtonBackgrounColor.hashCode ^
        disableButtonTitleBackgrounColor.hashCode ^
        checkboxColor.hashCode;
  }
}
