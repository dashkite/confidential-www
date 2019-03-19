`hash` is a convenience function that exposes the TweetNaCl.js implementation of [SHA-512][] hashing.

Message is enclosed in the type class [`Message`][]. To create a new `Message` from a given format, use the static method `Message.from`.

`hash` returns an instance of [`Hash`][], a type class that holds the value of the SHA-512 hash.  You may format the value via the instance method `to`.
