Base class for all keys in Panda-Confidential.

`Key` is a wrapper for the given key, formmated to be ready for use in TweetNaCl.js functions, along with a type label to ensure correct application.

`Key` has helper methods to manage its data, summarized below. Please see the relevant section for more details.

- `to`: instance method to return formatted internal data. `to` returns the key itself, in whichever format you request.
- `isKind`: static method providing a boolean prototype chain check for `Key`

Typically, you will not directly use this class. But all other keys inherit its interface.
