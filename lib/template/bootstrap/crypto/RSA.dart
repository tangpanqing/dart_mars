class RSA {
  static String content = '''
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encryptAlias;
import 'package:pointycastle/asymmetric/api.dart';

class RSA {
  int _encryptStep;
  int _decryptStep;
  encryptAlias.Encrypter _encrypter;

  RSA({String publicKey, String privateKey, int length}) {
    _encryptStep = length ~/ 8 - 11;
    _decryptStep = length ~/ 8;

    RSAPublicKey rsaPublicKey =
        encryptAlias.RSAKeyParser().parse(publicKey) as RSAPublicKey;

    RSAPrivateKey rsaPrivateKey =
        encryptAlias.RSAKeyParser().parse(privateKey) as RSAPrivateKey;

    _encrypter = encryptAlias.Encrypter(
        encryptAlias.RSA(publicKey: rsaPublicKey, privateKey: rsaPrivateKey));
  }

  String encrypt(String plainText) {
    List<int> encryptList = [];
    for (int i = 0; i < plainText.codeUnits.length; i = i + _encryptStep) {
      List<int> encryptItem = plainText.codeUnits
          .sublist(i, min(i + _encryptStep, plainText.codeUnits.length));

      encryptAlias.Encrypted encrypted = _encrypter.encryptBytes(encryptItem);

      encryptList.addAll(encrypted.bytes);
    }

    return base64.encode(encryptList);
  }

  String decrypt(String encrypted) {
    List<int> decodeList = base64.decode(encrypted);
    List<int> decryptList = [];
    for (int i = 0; i < decodeList.length; i = i + _decryptStep) {
      List<int> decryptItem =
          decodeList.sublist(i, min(i + _decryptStep, decodeList.length));

      List<int> s = _encrypter.decryptBytes(encryptAlias.Encrypted(decryptItem));

      decryptList.addAll(s);
    }
    return String.fromCharCodes(decryptList);
  }
}
  ''';
}
