import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:kaiteki/translation/language_identificator.dart';
import 'package:kaiteki/translation/translator.dart';

class MLKitTranslator implements Translator {
  @override
  Future<String> translate(
    String input,
    String targetLanguage, [
    String? sourceLanguage,
  ]) async {
    OnDeviceTranslator? translator;

    try {
      translator = OnDeviceTranslator(
        sourceLanguage: BCP47Code.fromRawValue(sourceLanguage!)!,
        targetLanguage: BCP47Code.fromRawValue(targetLanguage)!,
      );
      return await translator.translateText(input);
    } finally {
      translator?.close();
    }
  }

  @override
  bool get supportsLanguageDetection => false;
}

class MLKitLanguageIdentificator implements LanguageIdentificator {
  @override
  Future<String?> identifyLanguage(String input) async {
    LanguageIdentifier? identifier;

    try {
      identifier = LanguageIdentifier(confidenceThreshold: 0.5);
      return await identifier.identifyLanguage(input);
    } finally {
      identifier?.close();
    }
  }
}
