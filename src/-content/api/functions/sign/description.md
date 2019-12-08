`sign` is a [generic function][] accepting signing keys and data to return a cryptographic signature.  `sign` and its counterpart [`verify`][] form a pair of opposing operations.

`sign` returns an instance of [`Declaration`][], a wrapper that holds the signed data, the public keys of the `signatories`, and the [ed25519][] `signatures`.  This class is suitable for [`verify`][].

`sign` expects `data` to be either an instance of [`Message`][] or [`Declaration`][]:

- When given a `Declaration`, `sign` appends a signature to the existing lists.

- When given a `Message`, `sign` generates a new `Declaration`.

You may format the data of a `Declaration` via the instance method `Declaration.to`.

> **Warning**: Encryption key pairs are incompatible with `sign` and causes `sign` to throw.
