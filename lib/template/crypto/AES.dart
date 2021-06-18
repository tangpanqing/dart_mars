class AES {
  static String content = '''
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encryptAlias;

///
/// String plainText = 'this is a test from aes';
/// Key key = Key.fromUtf8('my 32 length key................');
/// IV iv = IV.fromLength(16);
///
/// AESHelper aesHelper = AESHelper(key: key, iv: iv);
///
/// print(plainText);
/// String encrypted = aesHelper.encrypt(plainText);
/// print(encrypted);
///
/// String decrypted = aesHelper.decrypt(encrypted);
/// print(decrypted);
///
class AES {
  encryptAlias.Encrypter _encrypter;
  encryptAlias.IV _iv;

  AES(
      {encryptAlias.Key key,
      encryptAlias.IV iv,
      encryptAlias.AESMode mode = encryptAlias.AESMode.sic,
      String padding = 'PKCS7'}) {
    _iv = iv;
    _encrypter =
        encryptAlias.Encrypter(encryptAlias.AES(key, mode: mode, padding: padding));
  }

  String encrypt(String plainText) {
    encryptAlias.Encrypted encrypted = _encrypter.encrypt(plainText, iv: _iv);

    return base64.encode(encrypted.bytes);
  }

  String decrypt(String encrypted) {
    List<int> decodeList = base64.decode(encrypted);

    return _encrypter.decrypt(encryptAlias.Encrypted(decodeList), iv: _iv);
  }
}
  ''';
}
