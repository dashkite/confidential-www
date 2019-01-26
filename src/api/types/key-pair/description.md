Base class for all key pairs in Panda-Confidential.

`KeyPair` contains a pair of algorithmically related keys, instances of [`PrivateKey`]() and [`PublicKey`]().

`Key` has helper methods to manage its data, summarized below. Please see the relevant section for more details.

- `to`: instance method to return formatted internal data.
- `isKind`: static method providing a boolean prototype chain check for `KeyPair`

Typically, you will not directly use this class. But all other key pairs inherit its interface.
