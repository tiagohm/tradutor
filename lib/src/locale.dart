abstract class Locale {
  String get languageCode;
  String get countryCode;

  String get locale => countryCode != null && countryCode.isNotEmpty
      ? "${languageCode}_$countryCode"
      : languageCode;
}
