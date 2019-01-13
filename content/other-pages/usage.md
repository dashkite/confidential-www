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
{encrypt, decrypt} = confidential()
```
Because Panda-Confidential is extensible, it uses instantiation to prevent unexpected changes by third parties.  Once you have an instance, you can destructure its properties and get going!

Panda-confidential wraps the TweetNaCl.js interface with pairs of opposing functions:
1. `encrypt` and `decrypt`
2. `sign` and `verify`

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
{SymmetricKey, convert, encrypt, decrypt} = confidential()

do ->
  # Generate a symmetric key.
  aliceKey = await SymmetricKey.create()

  # Alice encrypts her data.
  message = "Hello, Alice!"
  plaintext = convert from: "utf8", to: "bytes", message
  envelope = await encrypt aliceKey, plaintext

  # Alice could store this serialized envelope somewhere if she wanted.
  blob = envelope.to "base64"
  # Sometime later, get back the `Envelope` instance.
  _envelope = Envelope.from "base64", blob

  # Alice decrypts that ciphertext with the same key.
  bytes = decrypt aliceKey, _envelope
  result = convert from: "bytes", to: "utf8", bytes
  result == message   # true
```

To ask `encrypt` to use symmetric encryption, we need an instance of `SymmetricKey`:
- Case 1 Prexisting Key
  ```coffeescript
  serializedKey =
  key = SymmetricKey.from "base64", serializedKey
  SymmetricKey.isType key  # true
  ```
  If we already have a key, we can instantiate a `SymmetricKey` by passing it to `SymmetricKey.from()`.

- Case 2 New Key
  ```coffeescript
  key = await SymmetricKey.create()
  SymmetricKey.isType key  # true
  ```
  If we want a _new_ key, we can invoke `create`.  And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

We just need to pass our `SymmetricKey` and the plaintext to `encrypt`. Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of symmetric encryption][tweetnacl-secretbox].  `encrypt` returns an instance of `Envelope`, a special container that keeps your ciphertext and nonce organized.

The `Envelope` instance has its own methods to facilitate serialization, allowing Alice to store her encrypted data somewhere as a base64 string blob.  She can then get it back on-demand.

`decrypt` opposes `encrypt` and works just as simply.  When we are ready to retrieve the original plaintext, we pass the same SymmetricKey to `decrypt`, along with the ciphertext.

`encrypt` and `decrypt` are purposefully agnostic to the content they process, be it text or binary media.  The API always operates on byte arrays, requiring you convert inputs into bytes and then dealing with byte array outputs.  But, Panda-Confidential provides `convert` to easily perform that transformation.


## Authenticated Asymmetric Encryption and Decryption
Alice would like to securely send a message to Bob.  This calls for [asymmetric encryption][pke], allowing Alice to encrypt a message only Bob can decrypt.  It's also part of best-practices to add _authentication_, to make sure Bob can confirm that Alice encrypted the message.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{EncryptionKeyPair, SharedKey, convert, encrypt, decrypt} = confidential()

do ->
  # Come up with key-pairs for Alice and Bob.
  Alice = await EncryptionKeyPair.create()
  Bob = await EncryptionKeyPair.create()

  # Alice authenticates with her private key and encrypts with Bob's public key.
  # Combine them into a SharedKey instance.
  ALICE_KEY = SharedKey.create Alice.privateKey, Bob.publicKey

  # Alice encrypts her data.
  message = "Hello, Bob!"
  plaintext = convert from: "utf8", to: "bytes", message
  envelope = await encrypt ALICE_KEY, plaintext

  # Alice serializes the resulting envelope for transport
  blob = envelope.to "base64"



  # Some time later, Bob gets the envelope...
  envelope = Envelope.from "base64", blob

  # He uses the inverse keys to make the _same_ SharedKey value.
  BOB_KEY = SharedKey.create Alice.publicKey, Bob.privateKey
  BOB_KEY.to "utf8" == ALICE_KEY.to "utf8"   # true

  # Bob decrypts the ciphertext he recieved.
  bytes = decrypt BOB_KEY, envelope
  result = convert from: "bytes", to: "utf8", bytes
  result == message  # true
```

To ask `encrypt` to use asymmetric encryption, we need to assign key-pairs to the people involved, one public (`PublicKey`) and one private (`PrivateKey`).
- Case 1 Prexisting Key Pair
  ```coffeescript
  serializedKeyPair =
  keyPair = EncryptionKeyPair.from "base64", serializedKeyPair
  EncryptionKeyPair.isType keyPair  # true
  ```
  If we already have a key, we can instantiate an `EncryptionKeyPair` by passing it to `EncryptionKeyPair.from()`.

- Case 2 New Key Pair
  ```coffeescript
  keyPair = await EncryptionKeyPair.create()
  EncryptionKeyPair.isType keyPair  # true
  ```
  If we want a _new_ key pair, we can invoke `create`.  This provides a key-pair suitable for encryption, but _not_ signing. And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

#### Authentication Comes Standard
TweetNaCl.js enforces the best-practice of combining encryption with authentication through the use of the `SharedKey`.  `SharedKey.create` accepts two keys, one `PublicKey` and one `PrivateKey`.  

So, Alice inputs her `PrivateKey` and Bob's `PublicKey`.

Bob inputs the inverse, Alice's `PublicKey` and his `PrivateKey`.  

The `SharedKey.create` method yields the same, shared secret for both Alice and Bob, independently.  Since only the `SharedKey` can decrypt the message, and only Alice's private key can make the shared key on her end, Bob can be confident that Alice encrypted the message he's decrypting.

We pass the `SharedKey` and the message to `encrypt`.  Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of asymmetric encryption][tweetnacl-box], returning an instance of `Envelope`, a special container that keeps your ciphertext and nonce organized.

The `Envelope` instance has its own methods to facilitate serialization, allowing Alice to send her encrypted data somewhere safely as a base64 string blob.

`decrypt` opposes `encrypt` and works just as simply.  When Bob is ready to decrypt the message, Bob creates the `SharedKey` and passes it and the ciphertext to `decrypt`, returning the original message.

`encrypt` and `decrypt` are purposefully agnostic to the content they process, be it text or binary media.  The API always operates on byte arrays, requiring you convert inputs into bytes and then dealing with byte array outputs.  But, Panda-Confidential provides `convert` to easily perform that transformation.


## Signing and Verifying Messages
Alice wishes to publish a message, claim authorship, and ensure that her claim cannot be attributed to an altered version.  This calls for [digitial signature][digitial-signature].

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{SignatureKeyPair, convert, sign, verify} = confidential()

do ->
  # Come up with signing key-pairs for Alice and Bob.
  Alice = await SignatureKeyPair.create()
  Bob = await SignatureKeyPair.create()

  # Alice signs her message.
  message = "Hello World!"
  data = convert from: "utf8", to: "bytes", message
  declaration = sign Alice, data

  # Alice serializes the signature for transport.
  blob = declaration.to "base64"  




  # Some time later, Bob looks at the signed message...
  declaration = Declaration.from "base64", blob

  # Bob would like to verify that Alice truly signed this message.
  result = verify declaration
  result == true   # true

  # Bob decides to also sign the message
  declaration = sign Bob, declaration

  # Some time later, Charlotte verifies the signatures from Alice and Bob.
  result = verify signedMsg
  result == true  # true
```

Digital signing relies on public key identity, so you need to handle key-pairs similar to those in asymmetric encryption.  To avoid any confusion (and to enforce the best practice of separate encryption and signing keys), TweetNaCl.js makes these key pairs incompatible.

- Case 1 Prexisting Key Pair
  ```coffeescript
  serializedKeyPair =
  keyPair = SignatureKeyPair.from "base64", serializedKeyPair
  SignatureKeyPair.isType keyPair  # true
  ```
  If we already have a key, we can instantiate an `SignatureKeyPair` by passing it to `SignatureKeyPair.from()`.

- Case 2 New Key Pair
  ```coffeescript
  keyPair = await SignatureKeyPair.create()
  SignatureKeyPair.isType keyPair  # true
  ```
  If we want a _new_ key pair, we can invoke `create`.  This provides a key-pair suitable for signing, but _not_ encryption. And don't worry — TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].

To sign a message, we just need to pass the signing public and private keys (or together as a key pair) and the message to `sign`. Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of digital signing][tweetnacl-sign].  

`sign` returns an instance of `Declaration`, a special container that keeps your signature data organized.  It contains the original message, the signatories to that message (their public keys), and the digitial signatures generated by their respective private keys.  

Multiple people can sign a single message by just passing the `Declaration` instance to `sign` again with a different signing key pair.  The relevant data will be appened to the signatories and signatures fields.

The `Declaration` instance has its own methods to facilitate serialization, allowing Alice to send her declaration somewhere as a base64 string blob.

`verify` opposes `sign` and works just as simply.  Everything needed for verification is contained within an instance of `Declaration`, so just pass it to `verify`.  `verify` returns the boolean result of the verification of _all_ signatures.

Please note that while `verify` confirms the self-consistency of the `Declaration`, it does not guarantee that the public keys within actually belong to the people that posted the message.  It is up to you to compare the public keys listed in a `Declaration` to an authoritative record of their identity.


[api-docs]:/API.html
[symmetric-encryption]: https://en.wikipedia.org/wiki/Symmetric-key_algorithm
[pke]: https://en.wikipedia.org/wiki/Public-key_cryptography
[digitial-signature]: https://en.wikipedia.org/wiki/Digital_signature

[tweetnacl-randombytes]:https://github.com/dchest/tweetnacl-js#random-bytes-generation
[tweetnacl-secretbox]: https://github.com/dchest/tweetnacl-js#secret-key-authenticated-encryption-secretbox
[tweetnacl-box]:https://github.com/dchest/tweetnacl-js#public-key-authenticated-encryption-box
[tweetnacl-sign]:https://github.com/dchest/tweetnacl-js#signatures
