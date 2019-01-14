# Using Panda-Confidential
Cryptography is hard.  But panda-confidential enforces best practices in a simple form to make it easy and powerful.  Here are some common scenarios where its simplicity shines.

_Please see the [full API documentation][api-docs] for more detailed information._

# Contents
- [Getting Started](#getting-started)
- [Symmetric Encryption and Decryption](#symmetric-encryption-and-decryption)
- [Authenticated Asymmetric Encryption and Decryption](#authenticated-asymmetric-encryption-and-decryption)
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

She starts by importing Panda-Confidential.
```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{SymmetricKey, Plaintext, Envelope, encrypt, decrypt} = confidential()
do ->
```

Now, Alice needs to instantiate her key.  Because this is symmetric encryption, she needs a `SymmetricKey`.
### Case 1: Prexisting Key
```coffeescript
  serializedKey =
  aliceKey = SymmetricKey.from "base64", serializedKey
```
If Alice already has a key serialized somewhere, she can instantiate a `SymmetricKey` by passing it to the static method `SymmetricKey.from()`.

### Case 2: New Key

```coffeescript
  aliceKey = await SymmetricKey.create()
```
If Alice wants a _new_ key, she can use the static method `SymmetricKey.create()`.  Be sure to `await` on this method, as it returns a promise.  TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].


### Encryption
Now that Alice has her `SymmetricKey`, she needs to prepare a `Plaintext` container for the data she wants to encrypt.  She can use its static method `Plaintext.from()` to instantiate one.

Alice now has all the arguments she needs to use `encrypt`.
```coffeescript
  message = "Hello, Alice!"
  plaintext = Plaintext.from "utf8", message
  envelope = await encrypt aliceKey, plaintext
```

Be sure to `await` on this function, as it returns a promise.  Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of symmetric encryption][tweetnacl-secretbox].  

### Envelope and Serialization
`encrypt` returns an instance of `Envelope`, a special container that keeps Alice's ciphertext and nonce organized.

The `Envelope` instance has its own methods to facilitate serialization, allowing Alice to store her encrypted data somewhere as a base64 string.  She can then get it back on-demand.

```coffeescript
  # Alice can store this string.
  string = envelope.to "base64"  

  # Sometime later, Alice can recover her Envelope instance
  # with the `from` static method.
  newEnvelope = Envelope.from "base64", string
```

### Decryption
`decrypt` opposes `encrypt` and works just as simply.  When Alice is ready to retrieve the original plaintext, she passes the same SymmetricKey to `decrypt`, along with the `Envelope` instance.

```coffeescript

  # Alice decrypts that ciphertext with the same key.
  plaintext = decrypt aliceKey, newEnvelope

  # To format the plaintext as a string again, use the instance method `to`
  stringResult = plaintext.to "utf8"
```

`decrypt` returns a new `Plaintext` instance, keeping the interface symmetric to `encrypt`.  If Alice would like to view the plaintext data as a string, she can use the `Plaintext` instance method `to`.




















## Authenticated Asymmetric Encryption and Decryption
Alice would like to securely send a message to Bob.  This calls for [asymmetric encryption][pke], allowing Alice to encrypt a message only Bob can decrypt.  It's also part of best-practices to add _authentication_, to make sure Bob can confirm that Alice encrypted the message.

They start by importing Panda-Confidential.
```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{EncryptionKeyPair, SharedKey, Plaintext, Envelope, encrypt, decrypt} = confidential()
```

Now, both Alice and Bob need an instance of `EncryptionKeyPair` to perform this operation.
### Case 1: Prexisting Key Pair
```coffeescript
aliceSerialize = ""
bobSerialized = ""
Alice = EncryptionKeyPair.from "base64", aliceSerialized
Bob = EncryptionKeyPair.from "base64", bobSerialized
```
If they already have key pairs serialized somewhere, Alice and Bob can instantiate an `EncryptionKeyPair` by passing it to `EncryptionKeyPair.from()`.

### Case 2: New Key Pair
```coffeescript
Alice = await EncryptionKeyPair.create()
Bob = await EncryptionKeyPair.create()
EncryptionKeyPair.isType keyPair  # true
```
If they want _new_ key pairs, Alice and Bob can use the static method `EncryptionKeyPair.create()`. This provides a key-pair suitable for encryption, but _not_ signing.  TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].  Be sure to `await` on this method, as it returns a promise.

### SharedKey or "Authentication Comes Standard"
```coffeescript
# Alice and Bob make their shared keys independently,
# but I show them together here.
alice = SharedKey.create Alice.privateKey, Bob.publicKey
bob =   SharedKey.create Alice.publicKey, Bob.privateKey
```
TweetNaCl.js provides authentication through the use of the `SharedKey`.  The static method `SharedKey.create` accepts two keys, one `PublicKey` and one `PrivateKey`.  

Once Alice and Bob have their key pairs, they keep their `PrivateKey` secret and send their `PublicKey` to each other.

Alice makes a `SharedKey` using her `PrivateKey` and Bob's `PublicKey`.

Bob makes a `SharedKey` with the inverse, Alice's `PublicKey` and his `PrivateKey`.  

Because of the mathematics underlying public-key cryptography, Alice and Bob will both get the same value from `SharedKey.create`, independently.

That is,
```coffeescript
assert.equal (alice.to "base64"), (bob.to "base64")
```

This is good because both Alice and Bob can encrypt / decrypt the message. But also, because Alice and Bob keep their `PrivateKey`s secret from the world, only they could generate a `SharedKey` with this value.  

To put that another way, Bob can be confident that Alice, _and only Alice_, could have encrypted this message.  That's authentication.

### Encryption
Now that Alice has her `SharedKey`, she needs to prepare a `Plaintext` container for the data she wants to encrypt.  She uses its static method `Plaintext.from()` to instantiate one.

Alice now has all the arguments she needs to use `encrypt`.
```coffeescript
  message = "Hello, Bob!"
  plaintext = Plaintext.from "utf8", message
  envelope = await encrypt alice, plaintext
```

Be sure to `await` on this function, as it returns a promise.  Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of asymmetric encryption][tweetnacl-box].  

### Envelope and Serialization
`encrypt` returns an instance of `Envelope`, a special container that keeps Alice's ciphertext and nonce organized.

The `Envelope` instance has its own methods to facilitate serialization, allowing Alice to store her encrypted data somewhere as a base64 string.  Bob can then get it back on-demand.

```coffeescript
  # Alice can send this string safely.
  string = envelope.to "base64"  

  # Sometime later, Bob can recover Alice's Envelope instance
  # with the `from` static method.
  bobEnvelope = Envelope.from "base64", string
```

### Decryption
`decrypt` opposes `encrypt` and works just as simply.  When Bob is ready to retrieve the original plaintext, he passes his `SharedKey` to `decrypt`, along with the `Envelope` instance.

```coffeescript

  # Alice decrypts that ciphertext with the same key.
  plaintext = decrypt bob, bobEnvelope

  # To format the plaintext as a string again, use the instance method `to`
  stringResult = plaintext.to "utf8"
```

`decrypt` returns a new `Plaintext` instance, keeping the interface symmetric to `encrypt`.  If Bob would like to view the plaintext data as a string, he can use the `Plaintext` instance method `to`.











## Signing and Verifying Messages
Alice wishes to publish a message, claim authorship, and ensure that her claim cannot be attributed to an altered version.  This calls for [digitial signature][digitial-signature].

She starts by importing Panda-Confidential.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{SignatureKeyPair, Plaintext, Declaration, sign, verify} = confidential()
```

Digital signing relies on public key identity, so you need to handle key-pairs similar to those in asymmetric encryption.  To avoid any confusion (and to enforce the best practice of separate encryption and signing keys), TweetNaCl.js makes these key pairs incompatible.

### Case 1: Prexisting Key Pair
```coffeescript
aliceSerialized =
Alice = SignatureKeyPair.from "base64", aliceSerialized
```
If Alice already has a key pair serialized somewhere, she can instantiate a `SignatureKeyPair` by passing it to `SignatureKeyPair.from()`.

### Case 2: New Key Pair
```coffeescript
Alice = await SignatureKeyPair.create()
```
If Alice wants a _new_ key pair, she can use the static method `SignatureKeyPair.create`.  This provides a key-pair suitable for signing, but _not_ encryption. TweetNaCl.js provides a way to get [robust randomness regardless of platform][tweetnacl-randombytes].  Be sure to `await` on this method, as it returns a promise.

### Signing
Now that Alice has her `SignatureKeyPair`, she needs to prepare a `Plaintext` container for the data she wants to sign.  She uses its static method `Plaintext.from()` to instantiate one.

Alice now has all the arguments she needs to use `sign`.
```coffeescript
  message = "Hello, Bob!"
  plaintext = Plaintext.from "utf8", message
  declaration = sign Alice, plaintext
```

Under the hood, Panda-Confidential is uses the [TweetNaCl.js implementation of digital signing][tweetnacl-sign].

### Declaration and Serialization
```coffeescript
serialized = declaration.to "base64"

# Sometime later, Bob can pick up that serialized declaration and hydrate
newDeclaration = Declaration.from "base64", serialized
```

`sign` returns an instance of `Declaration`, a special container that keeps your signature data organized.  It contains the original message, the signatories to that message (their public keys), and the digital signatures generated by their respective private keys.

The `Declaration` instance has its own methods to facilitate serialization, allowing Alice to send her signed data somewhere as a base64 string.  Bob can then get it back on-demand.

### Verifying Signatures
```coffeescript
# Bob would like to verify that Alice truly signed this message.
# result is `true` or `false`.
result = verify newDeclaration
```

`verify` opposes `sign`.  Everything needed for verification is contained within an instance of `Declaration`, so Bob just passes it to `verify`.  `verify` returns the boolean result of the verification. If there is more than one signature, _all_ must verify successful for the result to be `true`.

Please note that while Bob can use `verify` to confirm the self-consistency of the `Declaration`, it does not guarantee that the public key inside actually belongs to Alice.  It is up to Bob to compare this `Declaration`'s public key to an authoritative source for Alice's `PublicKey`.

### Appending Signatures  

```coffeescript
# Bob decides to also sign the message
Bob = await SignatureKeyPair.create()
declaration = sign Bob, newDeclaration

# declaration now has `signatories` and `signatures` fields with length == 2.
```

Bob can also sign this `Declaration`.  He just passes the `Declaration` instance to `sign` again with his signing key pair.  The relevant data will be appended to the signatories and signatures fields within the `Declaration` instance.


[api-docs]:/API.html
[symmetric-encryption]: https://en.wikipedia.org/wiki/Symmetric-key_algorithm
[pke]: https://en.wikipedia.org/wiki/Public-key_cryptography
[digitial-signature]: https://en.wikipedia.org/wiki/Digital_signature

[tweetnacl-randombytes]:https://github.com/dchest/tweetnacl-js#random-bytes-generation
[tweetnacl-secretbox]: https://github.com/dchest/tweetnacl-js#secret-key-authenticated-encryption-secretbox
[tweetnacl-box]:https://github.com/dchest/tweetnacl-js#public-key-authenticated-encryption-box
[tweetnacl-sign]:https://github.com/dchest/tweetnacl-js#signatures
