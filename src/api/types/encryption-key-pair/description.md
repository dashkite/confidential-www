Key pair suitable for [asymmetric encryption][].

> **Warning:** `EncryptionKeyPair` is not suitable for signing.

`EncryptionKeyPair` extends [`KeyPair`][], so it inherits its inteface: (Please see that class for more details.)
- `to`: instance method to return formatted internal data.
- `isKind`: static method providing a boolean prototype chain check for `KeyPair`

`EncryptionKeyPair` extends that interface with:
- `create`: static method to generate an instance of `EncryptionKeyPair`, suitable for encryption.
- `from`: static method to hydrate an instance of `EncryptionKeyPair` from data
- `isType`: static method providing a boolean type-check for `EncryptionKeyPair`
