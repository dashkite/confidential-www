Generates an array of `length` pseudo-random bytes of cryptographic quality.

By default, this is the [TweetNaCl.js `randomBytes` implmentation](https://github.com/dchest/tweetnacl-js#random-bytes-generation), which selects the underlying interface most appropriate for a given environment.  When such an interface cannot be accessed, this function throws.

`randomBytes` is used internally to generate keys and nonces. You may replace `randomBytes` when instanciating [`confidential`][]. Please use caution when replacing `randomBytes`.  Inadequate sources of psuedo-randomness compromise encryption.

Because this interface is extensible, `randomBytes` return value is always wrapped in a promise to support possibly asynchronous sources.
