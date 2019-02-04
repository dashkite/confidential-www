Performs a [SHA-512][] hash of the input plaintext.

`hash` is a convenience function that exposes the TweetNaCl.js implementation of [SHA-512][] hashing.

Plaintext is enclosed in the type class [`Plaintext`][]. To create a new `Plaintext` from a given format, use the static method `Plaintext.from`.  `

`hash` returns an instance of [`Hash`][], a type class that holds the value of the SHA-512 hash.  You may format the value via the instance method `to`.
