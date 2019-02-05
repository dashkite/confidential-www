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
