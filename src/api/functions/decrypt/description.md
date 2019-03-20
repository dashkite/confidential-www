`decrypt` is a [generic function][], accepting an encryption key and ciphertext to return a plaintext.

 - When given a [`SymmetricKey`][], `decrypt` uses [symmetric decryption][symmetric encryption].

 - When given a [`SharedKey`][], `decrypt` uses authenticated, [asymmetric decryption][asymmetric encryption].

The ciphertext must encapsulated in an instance of [`Envelope`][], returned by [`encrypt`][]. You may use [`Envelope.from`][] to derive an instance from an encoded envelope.

`decrypt` returns an instance of [`Message`][], and the original plaintext can be restored using [`Message::to`][].

If `decrypt` cannot decrypt a ciphertext (ex: the incorrect key is provided), it throws.
