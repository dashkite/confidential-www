`hash` is a convenience function that exposes the TweetNaCl.js implementation of [SHA-512][] hashing.

Place the data to hash in an instance of [`Message`][] using the [`Message.from`][] class method.

`hash` returns an instance of [`Hash`][], which encapsulates the SHA-512 hash.  You may format the value via the instance method [`Hash::to`][].
