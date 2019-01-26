A wrapper for a given nonce of random bytes.

`Nonce` has helper methods to manage its data, summarized below. Please see the relevant section for more details.

- `to`: instance method to return formatted internal data. `to` returns the nonce itself, in whichever format you request.
- `from`: static method to hydrate an instance of `Nonce` from data
- `isType`: static method providing a boolean type-check for `Nonce`
