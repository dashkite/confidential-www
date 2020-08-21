Defaults to the [TweetNaCl.js `randomBytes` implementation](https://github.com/dchest/tweetnacl-js#random-bytes-generation), which selects the underlying interface most appropriate for a given environment. When such an interface cannot be accessed, this function throws.

`randomBytes` is used internally to generate keys and nonces. You may replace `randomBytes` when instantiating [`confidential`][].

> **Warning** Use caution when replacing `randomBytes`. Inadequate sources of psuedo-randomness will compromise your encryption.

`randomBytes` returns a promise to support possibly asynchronous operation.
