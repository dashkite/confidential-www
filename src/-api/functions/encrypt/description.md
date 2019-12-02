`encrypt` is a [generic function][], accepting an encryption key and plaintext to return a ciphertext wrapper that can be decrypted with [`decrypt`][].

 - When given a [`SymmetricKey`][], `encrypt` uses [symmetric encryption][].

 - When given a [`SharedKey`][], `encrypt` uses authenticated, [asymmetric encryption][].

> **Warning**: Signing key pairs are incompatible with `encrypt` and causes `encrypt` to throw.

You may use an existing nonce (such as a counter), using [`Nonce.from`][]. The nonce must be `nacl.box.nonceLength` bytes long.

> **Warning**: Re-using a nonce can compromise your private keys.

The plaintext must be first placed in a [`Message`][] container using the [`Message.from`][] class method.

`encrypt` returns a [`Promise`][] that yields [`Envelope`][], which encapsulates the ciphertext and nonce. This container may be passed to [`decrypt`][] to recover the original plaintext. You may format the envelope using [`Envelope::to`][].
