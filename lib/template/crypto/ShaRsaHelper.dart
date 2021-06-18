class ShaRsaHelper {
  static String content = '''
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart' as pointycastle;

class ShaRsaHelper {
  final String _algorithmName;

  ShaRsaHelper(this._algorithmName);

  String generateSignature(String message, String privateKey) {
    RSAPrivateKey rsaPrivateKey =
        RSAKeyParser().parse(privateKey) as RSAPrivateKey;

    var privParams = pointycastle.ParametersWithRandom(
        pointycastle.PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey), null);

    var privSigner = pointycastle.Signer(_algorithmName);
    privSigner.reset();
    privSigner.init(true, privParams);

    RSASignature signature =
        privSigner.generateSignature(Uint8List.fromList(message.codeUnits));
    String dey = base64.encode(signature.bytes);

    return dey;
  }

  bool verifySignature(String message, String publicKey, String generate) {
    RSAPublicKey rsaPublicKey = RSAKeyParser().parse(publicKey) as RSAPublicKey;

    var pubParams = pointycastle.ParametersWithRandom(
        pointycastle.PublicKeyParameter<RSAPublicKey>(rsaPublicKey), null);

    var pubSigner = pointycastle.Signer(_algorithmName);
    pubSigner.reset();
    pubSigner.init(false, pubParams);

    RSASignature rsaSignature = RSASignature(base64.decode(generate));
    bool b = pubSigner.verifySignature(
        Uint8List.fromList(message.codeUnits), rsaSignature);

    return b;
  }
}
''';
}
