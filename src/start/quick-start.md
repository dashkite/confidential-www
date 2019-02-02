## Quick Start

Install Panda-Confidential with npm, and use your favorite bundler to get it into the browser.

```shell
$ npm i panda-confidential
```

When you import the library into your code, grab the [`confidential`][] submodule directly.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{encrypt, decrypt} = confidential()
```
Because Panda-Confidential is extensible, it uses instantiation to prevent unexpected changes by third parties.  Once you have an instance, you can destructure its properties and get going!

Panda-confidential wraps the [TweetNaCl.js][] interface with pairs of opposing functions:

1. [`encrypt`][] and [`decrypt`][]
2. [`sign`][] and [`verify`][]

These functions are [_generics_][generic function], accepting multiple inputs and deciding what action to take.  But details—like key length, robust randomness, algorithm, and so forth—are all handled by [TweetNaCl.js][].

Panda-Confidential establishes a type system, and the above generics use those to determine your intention in a clear and error-free way.  That is, you can't accidentally a key for an operation it's not designed for.

Here are the key types:

- [`SymmetricKey`][]
- [`PrivateKey`][]
- [`PublicKey`][]
- [`SharedKey`][]

…and the key-pair types:

- [`EncryptionKeyPair`][]
- [`SignatureKeyPair`][]

_Please see the [full API documentation](/api) for more detailed information._
