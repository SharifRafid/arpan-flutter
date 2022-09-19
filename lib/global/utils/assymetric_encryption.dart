import 'package:crypton/crypton.dart';

class AsymmetricCrypt{
  final String _key;
  RSAPublicKey? _publicKey;
  RSAPrivateKey? _privateKey;

  AsymmetricCrypt(this._key);

  String encrypt(String plain) {
    _publicKey = RSAPublicKey.fromPEM(_key);
    return _publicKey!.encrypt(plain);
  }

  String decrypt(String data) {
    _privateKey = RSAPrivateKey.fromPEM(_key);
    return _privateKey!.decrypt(data);
  }
}