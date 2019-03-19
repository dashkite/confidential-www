`Message` is a wrapper for plaintext data.

`Message` has helper methods to manage its data, summarized below. Please see the relevant section for more details.

- `to`: instance method to return formatted internal data. `to` returns the plaintext itself, in whichever format you request.
- `from`: static method to hydrate an instance of `Message` from data
- `isType`: static method providing a boolean type-check for `Message`
