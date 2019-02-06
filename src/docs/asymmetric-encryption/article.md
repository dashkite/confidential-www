# Authenticated Asymmetric Encryption

Alice would like to securely send a message to Bob. This calls for [asymmetric encryption][pke], allowing Alice to encrypt a message only Bob can decrypt. Bob also wants to confirm that the message is really from Alice, which requires [authenticated encryption][].

Alice begins by importing Panda-Confidential and instantiating the API.

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate Panda-Confidential
{EncryptionKeyPair, SharedKey, Plaintext,
  Envelope, encrypt} = confidential()
```

## Obtaining A Shared Key

Since this is asymmetric encryption, Alice will use her private key and Bob's public key to create a  [`SharedKey`][], which she'll use to encrypt the message to Bob. This also means that Bob can be confident someone isn't trying to impersonate her.

### Always Authenticated

Confidential, following the lead of TweetNaCl.js, does not provide an option for unauthenticated asymmetric encryption.

To create a `SharedKey`, Alice must first obtain her private key and Bob's public key.

### Case 1: Pre-Existing Key Pairs

If Alice already has an [`EncryptionKeyPair`][], she may retrieve and deserialize it with the static method `from`.

```coffeescript
alice = EncryptionKeyPair.from "base64", serializedKeyPair
```

> **Warning:** Encryption key pairs should be stored securely because they contain private keys.

Similarly, she may deserialize Bob's public key.

```coffeescript
bob = publicKey: PublicKey.from "base64", serializedPublicKey
```

### Case 2: New Key Pair

If Alice wants a _new_ key, she can use the static method [`create`][].This provides a key-pair suitable for encryption (but _not_ for signing, which requires a [`SignatureKeyPair`][]).

[TweetNaCl.js][] ensures that Alice's key is random, providing [robust randomness regardless of platform][tweetnacl-randombytes]. On some platforms, that's an asynchronous operation, so Confidential returns a promise to provide a consistent interface.

Alice uses `await` to wait for the promise to resolve.


```coffeescript
alice = await EncryptionKeyPair.create()
```

Alice should share the resulting public key with Bob and securely store the private key so that she can use them again later.

### Creating The Shared Key

Equipped with Bob's public key and her own private key, Alice can now create the shared key.

```coffeescript
key = SharedKey.create alice.privateKey, bob.publicKey
```

## Encrypting

Alice prepares a [`Plaintext`][] container for the data she wants to encrypt. She can use the static method `from`, which works the same way as it does for `EncryptedKeyPair` and `PublicKey`.

```coffeescript
plaintext = Plaintext.from "utf8", "Hello, Bob!"
```

Alice may now [`encrypt`][] the `Plaintext` object. She uses `await` because `encrypt` returns a promise.

```coffeescript
envelope = await encrypt key, plaintext
```

Under the hood, Panda-Confidential uses the [TweetNaCl.js implementation of asymmetric encryption][tweetnacl-box], which requires a nonce. Confidential will generate one for you if you don't provide one. `encrypt` returns an [`Envelope`][] instance, which includes both the ciphertext and the nonce.

## Serializing

Alice serializes the envelope so she can send it to Bob more easily.

```coffeescript
string = envelope.to "base64"
```

## Deserializing

Once Bob gets the serialized envelope, he can deserialize it again so that he can decrypt and read the message.

```coffeescript
envelope = Envelope.from "base64", string
```

## Decrypting

[`decrypt`][] and works just as simply as `encrypt`. However, Bob must first create a shared key, just as Alice did. Bob's shared key will be constructed from his private key and Alice's public key, the reverse of the way Alice created her shared key.

Thanks to the mathematics underlying public-key cryptography, Bob will still end up with the same shared key, which will allow him to decrypt Alice's message. That is,

_s(a, B) = s(A, b)_

where _s_ is a function returning a shared key, _A_ and _B_ are public keys and _a_ and _b_ are the corresponding private keys.

And because the shared key can only have been created with knowledge of either his private key or Alice's, Bob can be confident that the message is from Alice.

Once Bob has created a shared key from his private key and Alice's public key, he can decrypt the message.

```coffeescript
plaintext = decrypt key, envelope
```

To read Alice's message, Bob uses the `to` method, which works just as it did for the envelope.

```coffeescript
# returns 'Hello, Bob!'
message = plaintext.to "utf8"
```

Bob may respond to the message using the same shared key, effectively creating a secure communication channel between Alice and Bob.
