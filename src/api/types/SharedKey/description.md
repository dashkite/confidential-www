`SharedKey` is derived algorithmically from one [`PublicKey`][] (suitable for encryption) and one [`PrivateKey`][] (suitable for encryption).  That allows two people to, independently, generate the same _shared_ secret key and conduct authenticated encryption/decryption.

> **Warning:** This key must remain secret for the encryption to be effective.

`SharedKey` extends [`Key`][], so it inherits its inteface: (Please see that class for more details.)
- `to`: instance method to return formatted internal data. `to` returns the key itself, in whichever format you request.
- `isKind`: static method providing a boolean prototype chain check for `Key`

`SharedKey` extends that interface with:
- `create`: static method to generate an instance of `SharedKey` suitable for [asymmetric encryption][]
- `from`: static method to hydrate an instance of `SharedKey` from data
- `isType`: static method providing a boolean type-check for `SharedKey`
