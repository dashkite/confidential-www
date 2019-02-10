`sign` is a [generic function][] accepting signing keys and data to return a digital signature.  `sign` and its counterpart [`verify`][] form a pair of opposing operations.

Panda-Confidential establishes a type system to determine your intention in a clear and error-free way.  That allows `sign` to accept either a [`SignatureKeyPair`][] or keys as individual arguments.

> **Warning**: Encryption key pairs are incompatible with `sign` and causes `sign` to throw.

`sign` returns an instance of [`Declaration`][], a type class that holds the holds the original data, the public keys of the `signatories`, and the [ed25519][] `signatures`.  This class is suitable for [`verify`][].

`sign` expects `data` to be either an instance of [`Plaintext`][] or [`Declaration`][]:
  - When given a `Declaration`, `sign` appends a signature to the existing lists.
  - When given a `Plaintext`, `sign` generates a new `Declaration`.

You may format the data of a `Declaration` via the instance method `Declaration.to`.
