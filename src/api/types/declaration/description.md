`Declaration` contains the products of cryptographic signature: the original `data`, the public keys of the `signatories`, and the [ed25519][] `signatures`.

This class is suitable for [`verify`][].

> **Warning:** While a `Declaration` can be verified to be self-consistent, it is your responsiblity to verify the public keys in the `signatories` list belong to whomever claims them.

`Declaration` contains helper methods to manage its data, summarized below.  Please see the relevant section for more details.

- `to`: instance method to return formatted internal data
- `from`: static method to hydrate an instance of `Declaration` from data
- `isType`: static method providing a boolean type-check for `Declaration`
