`Hash` is a wrapper for the [SHA-512][] hash of a document.

`Hash` has helper methods to manage its data, summarized below. Please see the relevant section for more details.

- `to`: instance method to return formatted internal data. `to` returns the hash itself, in whichever format you request.
- `from`: static method to hydrate an instance of `Hash` from data
- `isType`: static method providing a boolean type-check for `Hash`
