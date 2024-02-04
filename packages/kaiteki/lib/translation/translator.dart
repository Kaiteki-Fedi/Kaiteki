abstract class Translator {
  bool get supportsLanguageDetection;

  Future<String> translate(
    String input,
    String destinationLanguage, [
    String? sourceLanguage,
  ]);
}
