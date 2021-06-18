class Sha1WithRSA {
  static String content = '''
import 'ShaRsaHelper.dart';

class Sha1WithRSA {
  static final String _algorithmName = 'SHA-1/RSA';

  static String generateSignature(String message, String privateKey) =>
      ShaRsaHelper(_algorithmName).generateSignature(message, privateKey);

  static bool verifySignature(
          String message, String publicKey, String generate) =>
      ShaRsaHelper(_algorithmName)
          .verifySignature(message, publicKey, generate);
}
''';
}
