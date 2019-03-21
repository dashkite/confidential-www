`Declaration` contains the products of a cryptographic signature: the original `data`, the public keys of the `signatories`, and the [ed25519][] `signatures`.

Produced by [`sign`][] and consumed by [`verify`][].

> **Warning:** While a `Declaration` can be verified to be self-consistent, it is your responsiblity to verify the public keys in the `signatories` list belong to whomever claims them.
