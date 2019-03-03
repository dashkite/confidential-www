`decrypt` is a [generic function][], accepting an encryption key and ciphertext to return a plaintext.  `decrypt` and its counterpart [`encrypt`][] form a pair of opposing operations.

Panda-Confidential establishes a type system to determine your intention in a clear and error-free way.  That allows `decrypt` behavior to depend on the input key:
 - When given a [`SymmetricKey`][], `decrypt` uses [symmetric decryption][symmetric encryption].
 - When given a [`SharedKey`][], `decrypt` uses authenticated, [asymmetric decryption][asymmetric encryption].

Ciphertext is enclosed in the type class [`Envelope`][], returned by [`encrypt`][].  If you wish to hydrate an `Envelope` from a serialized form, use the static method `Envelope.from` to do so.

`decrypt` returns an instance of [`Plaintext`][], a type class that holds the plaintext product of decryption.  You may format the data of a `Plaintext` via the instance method `Plaintext.to`.

If `decrypt` cannot decrypt a ciphertext (ex: the incorrect key is provided), it throws.
