abstract class LanguageIdentificator {
  /// Tries to identify the language.
  ///
  /// Returns null if no language was able to be identified.
  Future<String?> identifyLanguage(String input);
}
