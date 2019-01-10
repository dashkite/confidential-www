# Using Panda-Confidential
Cryptography is hard.  But panda-confidential enforces best practices in a simple form to make it easy and powerful.  Here are some common scenarios where its simplicity shines.

_Please see the [full API documentation][api-docs] for more detailed information._

# Contents
- [Getting Started](#getting-started)
- [Symmetric Encryption and Decryption](#symmetric-encrytion-and-decryption)
- [Authenticated Asymmetric Encryption and Decryption](#authenticated-asymmetric-encrytion-and-decryption)
- [Signing and Verifying Messages](#signing-and-verifying-messages)

## Getting Started
Install Panda-Confidential with npm, and use your favorite bundler to get it into the browser.

```shell
$ npm install panda-confidential —-save
```

When you import the library into your code, grab the `confidential` submodule directly.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{encrypt, decrypt, key} = confidential()
```
Because Panda-Confidential is extensible, it uses instantiation to prevent unexpected changes by third parties.  Once you have an instance, you can destructure its properties and get going!

Panda-confidential wraps the TweetNaCl.js interface with pairs of opposing functions:
1. `encrypt` and `decrypt`
2. `sign` and `verify`
3. `encode` and `decode`

These functions are [_generics_][generics], accepting multiple inputs and deciding what action to take.  But details — like key length, robust randomness, algorithm, etc — are all handled by TweetNaCl.js.

Panda-Confidential establishes a type system, and the above generics use those to determine your intention in a clear and error-free way.  That is, you can't accidentally a key for an operation it's not designed for.

Here are the key types...
- SymmetricKey
- PrivateKey
- PublicKey
- SharedKey

... and the key-pair types.
- EncryptionKeyPair
- SignatureKeyPair

_Please see the [full API documentation][api-docs] for more detailed information._

[generics]: https://en.wikipedia.org/wiki/Generic_programming
[api-docs]:https://github.com/pandastrike/panda-confidential/blob/master/API.md

## Symmetric Encryption and Decryption
Alice would like to encrypt her data at rest.  This calls for [symmetric encryption][symmetric-encryption], allowing Alice to encrypt and decrypt private data with the same key.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{key, encrypt, decrypt} = confidential()

do ->
  # Generate a symmetric key.
  aliceKey = await key.symmetric()

  # Alice encrypts her data.
  message = "Hello World!"
  ciphertext = await encrypt aliceKey, message

  # Some time later, Alice decrypts that ciphertext with the same key.
  result = decrypt aliceKey, ciphertext
  result == message   # true
```

To ask `encrypt` to use symmetric encryption, we need an instance of `SymmetricKey`, which we can access through its constructor `key.symmetric`.
1. If we already have a key, we can create a SymmetricKey by passing it to the constructor.
2. If we want a _new_ key, we can invoke the constructor without arguments to have Panda-Confidential generate an appropriate key.  And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

We just need to pass our SymmetricKey and the plaintext to `encrypt`. Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of symmetric encryption][tweetnacl-secretbox].  `encrypt` returns a Base64 encoded string ciphertext that we can store in a database.

`decrypt` opposes `encrypt` and works just as simply.  When we are ready to retrieve the original plaintext, we pass the same SymmetricKey to `decrypt`, along with the ciphertext to return the original plaintext.


## Authenticated Asymmetric Encryption and Decryption
Alice would like to securely send a message to Bob.  This calls for [asymmetric encryption][pke], allowing Alice to encrypt a message only Bob can decrypt.  It's also part of best-practices to add _authentication_, to make sure Bob can confirm that Alice encrypted the message.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{keyPair, key, encrypt, decrypt} = confidential()

do ->
  # Come up with key-pairs for Alice and Bob.
  Alice = await keyPair.encryption()
  Bob = await keyPair.encryption()

  # Alice authenticates with her private key and encrypts with Bob's public key.
  # Combine them into a SharedKey instance.
  ALICE_KEY = key.shared Alice.privateKey, Bob.publicKey

  # Alice encrypts her data.
  message = "Hello World!"
  ciphertext = await encrypt ALICE_KEY, message


  # Some time later, Bob gets the ciphertext...

  # He uses the inverse keys to make the _same_ SharedKey value.
  BOB_KEY = key.shared Alice.publicKey, Bob.privateKey
  BOB_KEY.encode() == ALICE_KEY.encode()   # true

  # Bob decrypts the ciphertext he recieved.
  result = decrypt BOB_KEY, ciphertext
  result == message  # true
```

To ask `encrypt` to use asymmetric encryption, we need to assign key-pairs to the people involved, one public (`PublicKey`) and one private (`PrivateKey`).
1. If we already have a key-pair, we can create a `PublicKey` and a `PrivateKey` by passing the key to the constructors `key.public` and `key.private`, respectively.
2. If we want a _new_ key-pair, we can invoke the constructor `keyPair.encryption` without arguments.  This provides a key-pair suitable for encryption, but _not_ signing. And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

#### Authentication Comes Standard
TweetNaCl.js enforces the best-practice of combining encryption with authentication through the use of the `SharedKey`.  Alice uses her `PrivateKey` and Bob's `PublicKey`. Bob uses the inverse, Alice's `PublicKey` and his `PrivateKey`.  The `key.shared` constructor yields the same, shared secret for both.  Since only the `SharedKey` can decrypt the message, and only Alice's private key can make the shared key on her end, Bob can be confident that Alice encrypted the message he outputs.

We pass the `SharedKey` and the message to `encrypt`.  Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of asymmetric encryption][tweetnacl-box], returning Base64 encoded string ciphertext that we can safely send over the network.

`decrypt` opposes `encrypt` and works just as simply.  Bob creates the `SharedKey` and passes it and the ciphertext to `decrypt`, returning the original message.


## Signing and Verifying Messages
Alice wishes to publish a message, claim authorship, and ensure that her claim cannot be attributed to an altered version.  This calls for [digitial signature][digitial-signature].

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{keyPair, sign, verify} = confidential()

do ->
  # Come up with signing key-pairs for Alice and Bob.
  Alice = await keyPair.signature()
  Bob = await keyPair.signature()

  # Alice signs her message.
  message = "Hello World!"
  signedMsg = sign Alice, message
  blob = signedMsg.encode()  # You can output Base64 string for transport


  # Some time later, Bob looks at the signed message...

  # Bob would like to verify that Alice truly signed this message.
  result = verify signedMsg
  result == true   # true

  # Bob decides to also sign the message
  signedMsg = sign Bob, signedMsg

  # Some time later, Charlotte verfies the signatures from Alice and Bob.
  result = verify signedMsg
  result == true  # true
```

Digital signing relies on public key identity, so you need to handle key-pairs similar to those in asymmetric encryption.  To avoid any confusion (and to enforce the best practice of separate encryption and signing keys), TweetNaCl.js makes these key pairs incompatible.

1. If we already have a key-pair, we can create a `PublicKey` and a `PrivateKey` by passing the key to the constructors `key.public` and `key.private`, respectively.
2. If we want a _new_ key-pair, we can invoke the constructor `keyPair.signature` without arguments.  This provides a key-pair suitable for signing, but _not_ encryption. And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

To sign a message, we just need to pass signing public and private keys (or together as a key-pair) and the message to `sign`. Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of digital signing][tweetnacl-sign].  `sign` returns an instance of `SignedMessage`, containing both the original message, the signature(s) generated with the `PrivateKey`(s), and the `PublicKey`(s) needed to verify the signature(s).  Multiple people can sign a single message, so just pass the `SignedMessage` instance to `sign` to add on signatures.

`verify` opposes `sign` and works just as simply.  Everything needed for verification is contained within an instance of SignedMessage, so just pass it to `verify`.  `verify` returns the boolean result of the verification of _all_ signatures.

While `verify` confirms the self-consistency of the `SignedMessage`, it does not guarantee that the public keys within belong to the people claimed.  It is up to you to compare the public keys listed in a `SignedMessage` to the public record of their identity.


[api-docs]:/API.html
[symmetric-encryption]: https://en.wikipedia.org/wiki/Symmetric-key_algorithm
[pke]: https://en.wikipedia.org/wiki/Public-key_cryptography
[digitial-signature]: https://en.wikipedia.org/wiki/Digital_signature

[tweetnacl-randombytes]:https://github.com/dchest/tweetnacl-js#random-bytes-generation
[tweetnacl-secretbox]: https://github.com/dchest/tweetnacl-js#secret-key-authenticated-encryption-secretbox
[tweetnacl-box]:https://github.com/dchest/tweetnacl-js#public-key-authenticated-encryption-box
[tweetnacl-sign]:https://github.com/dchest/tweetnacl-js#signatures
