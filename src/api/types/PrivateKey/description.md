`PrivateKey` extends [`Key`][], so it inherits its inteface: (Please see that class for more details.)
- `to`: instance method to return formatted internal data. `to` returns the key itself, in whichever format you request.
- `isKind`: static method providing a boolean prototype chain check for `Key`

`PrivateKey` extends that interface with:
- `from`: static method to hydrate an instance of `PrivateKey` from data
- `isType`: static method providing a boolean type-check for `PrivateKey`

Note that this key type cannot be created directly, but rather through the creation of an [`EncryptionKeyPair`][] or [`SignatureKeyPair`][].  Further, while both types of key pairs contain instances of `PrivateKey`, encryption and signing keys in Panda-Confidential cannot interoperate.
