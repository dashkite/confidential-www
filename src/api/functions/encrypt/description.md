Encrypts a plaintext with the provided key.

`encrypt` is a [generic function](), accepting an encryption key and plaintext to return a ciphertext.  `encrypt` and its counterpart [`decrypt`]() form a pair of opposing operations.

Panda-Confidential establishes a type system to determine your intention in a clear and error-free way.  That allows `encrypt` behavior to depend on the input key:
 - When given a [`SymmetricKey`](), `encrypt` uses [symmetric encryption](). If you pass in a `nonce`, it must be `nacl.secretbox.nonceLength` bytes long.
 - When given a [`SharedKey`](), `encrypt` uses authenticated, [asymmetric encryption](). If you pass in a `nonce`, it must be `nacl.box.nonceLength` bytes long.

> **Warning**: Signing key pairs are incompatible with `encrypt` and causes `encrypt` to throw.

Plaintext is enclosed in the type class [`Plaintext`](). To create a new `Plaintext` from a given format, use the static method `Plaintext.from`.  `

`nonce` is an optional argument, an instance of the type class [`Nonce`]().  To create a new `Nonce` from a given format, use the static method `Nonce.from`.  If you omit this arugment, `encrypt` automatically generates one from the [`randomBytes`]() interface.

`encrypt` returns a promise that yields [`Envelope`](), a type class to hold the ciphertext and nonce products of encryption. This container is suitable for [`decrypt`]().  You may format the value of an `Envelope` via the instance method `Envelope.to`.
