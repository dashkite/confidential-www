# Symmetric Encryption

Alice would like to encrypt her data at rest. This calls for [symmetric encryption][], allowing Alice to encrypt and decrypt private data with the same key.di

She starts by importing Panda-Confidential and instantiating the API.

```coffeescript
import {confidential} from "panda-confidential"

{SymmetricKey, Plaintext, Envelope,
 encrypt, decrypt} = confidential()
```

## Obtaining A Key

Since this is symmetric encryption, Alice needs a [`SymmetricKey`][].

### Case 1: Pre-Existing Key

If Alice already has a serialized key, she can retrieve it and instantiate a `SymmetricKey` by passing it to the static method `from`.

```coffeescript
key = SymmetricKey.from "base64", serializedKey
```

### Case 2: New Key

If Alice wants a _new_ key, she can use the static method [`create`][].

[TweetNaCl.js][] ensures that Alice's key is random by providing [robust randomness regardless of platform][tweetnacl-randombytes]. On some platforms, that's an asynchronous operation, so Confidential returns a promise to provide a consistent interface. Alice uses `await` to wait for the promise to resolve.

```coffeescript
key = await SymmetricKey.create()
```

## Encrypting

Now that Alice has her `SymmetricKey`, she needs to prepare a [`Plaintext`][] container for the data she wants to encrypt. She can use its static method `from`, which works the same way as it does for `SymmetricKey`.

```coffeescript
plaintext = Plaintext.from "utf8", "Hello, Alice!"
```

Alice may now [`encrypt`][] the `Plaintext` object. She uses `await` because `encrypt` returns a promise.

```coffeescript
envelope = await encrypt key, plaintext
```

Under the hood, Panda-Confidential uses the [TweetNaCl.js implementation of symmetric encryption][tweetnacl-secretbox], which requires a nonce. Confidential will generate one for you if you don't provide one. `encrypt` returns an [`Envelope`][] instance, which includes both the ciphertext and the nonce.

## Serializing

The `Envelope` instance supports serialization via the `to` method. Once the envelope is serialized, Alice may store her encrypted data as a string.

```coffeescript
string = envelope.to "base64"
```

## Deserializing

Later, Alice may restore the envelope with the `from` static method.

```coffeescript
envelope = Envelope.from "base64", string
```

## Decrypting

[`decrypt`][] works as simply as `encrypt`. Alice uses the same key she used to encrypt the plaintext to decrypt the envelope. `decrypt` returns a new `Plaintext` instance, just like the one she passed into `encrypt`.

```coffeescript
plaintext = decrypt key, envelope
```

To get back the original data, she uses the `to` method, which works just as it did for the envelope.

```coffeescript
assert.equal "Hello, Alice!", plaintext.to "utf8"
```
