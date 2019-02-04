The return value for [`encrypt`][].

`Envelope` contains the products of encryption: the `ciphertext` and `nonce`.

This class is suitable for [`decrypt`][].

`Envelope` contains helpers methods manage its, summarized below.  Please see the relevant section for more details.

- `to`: instance method to return formatted internal data
- `from`: static method to hydrate an instance of `Envelope` from data
- `isType`: static method providing a boolean type-check for `Envelope`
