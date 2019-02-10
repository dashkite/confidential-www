`sign` is a [generic function][] accepting a [`Declaration`] to return a boolean result on its integrity.  `verify` and its counterpart [`sign`][] form a pair of opposing operations.

`verify` throws without an instance of [`Declaration`][].  You may instanciate one from a serialized form with the static method `Declaration.from`.

`verify` returns `true` if _all_ [ed25519][] signatures can be verified with their corresponding public keys.  Otherwise, `verify` returns `false`.

> **Warning:** Everything needed to verify the signatures exists within a [`Declaration`][], but it is up to _you_ to verify the authenticity of the public keys within `signatories`.
