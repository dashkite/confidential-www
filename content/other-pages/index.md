A simple, extensible interface for the [TweetNaCl.js][tweetnacl] cryptography library

## Motivation
Cryptography is hard. Even subtle bugs in implementation can render your efforts insecure.  That inspired the creation of TweetNaCl and its JavaScript port, [TweetNaCl.js][tweetnacl].

TweetNaCl.js is an opinionated bundle of [universal JavaScript][universal] that distills cryptography best practices and is auditable. The code is short and introduces minimal abstraction. However, that lack of abstraction can make the API unwieldy.

Panda Confidential aims to make TweetNaCl.js easier to use and extend without giving up auditability.

[tweetnacl]: https://github.com/dchest/tweetnacl-js#documentation
[universal]: https://medium.com/@ghengeveld/isomorphism-vs-universal-javascript-4b47fb481beb


## Usage
Because panda-confidential is extensible, we use instantiation to prevent unexpected changes by third parties.

```coffeescript
import {confidential} from "panda-confidential"

do ->
  # Instantiate Panda-Confidential
  {encrypt, decrypt, convert, SymmetricKey} = confidential()
```

Panda-confidential wraps the TweetNaCl.js interface with pairs of opposing functions:
1. `encrypt` and `decrypt`
2. `sign` and `verify`

These functions are [_generics_][generics] and will accept multiple kinds of inputs determining the action taken.  To allow you to clearly and correctly express your intent, Panda Confidential establishes a type system.

For example, let's perform a symmetric encryption with a secret key.

```coffeescript
  # Generate symmetric key of correct length that should be saved.
  myKey = await Symmetric.create()

  # Person A symmetrically encrypts their data.
  message = convert from:"utf8", to: "bytes", "Hello World!"
  envelope = await encrypt myKey, message
```

The details -- key length, ensuring a robust source of randomness, encryption algorithm, etc -- are all handled by TweetNaCl.js.  `encrypt` and the type system just provides clear interface for that power.

Even the outputs of `encrypt` and `sign` are typed to organize the cryptographic products.

We can serialize that product by simply using:
```coffeescript
  blob = envelope.to "base64"
  # Store or transmit the base64-encoded string blob
```

Here we use `decrypt` to retrieve the data just as simply.
```coffeescript
  # Later, Person A decrypts that ciphertext.
  envelope = Envelope.from "base64", blob
  output = decrypt myKey, envelope
```

Please see the [full API documentation][api-docs] for more detailed information about key types and function pairs.

[generics]: https://en.wikipedia.org/wiki/Generic_programming

## Installation

For the browser, bundle using your favorite bundler:

```
npm install panda-confidential --save
```

## Features
Confidential provides generic functions for:
- encrypting and decrypting
- signing and verifying
- interconverting between type formats

These functions all make use of TweetNaCl.js, but the accept a variety of inputs to accomplish the desired operation.  Confidential has a system of key-types and key-pair-types to make the operations clear and error free.

[Full API Documentation][api-docs]

[api-docs]:/api
