# Why Confidential?

[NaCl][] (pronounced _salt_: NaCl is the chemical formula for sodium chloride, also known as salt, which is a [cryptographic pun](https://en.wikipedia.org/wiki/Salt_(cryptography))) provides a [state of the art implementation][Why NaCl?] of fundamental cryptographic operations. [TweetNaCl][] provides an auditable, self-contained implementation of NaCl that fits [within 100 Tweets](https://twitter.com/tweetnacl). Finally, [TweetNaCl.js][] implements TweetNaCl in JavaScript. This gives us this auditable, state-of-the-art cryptography in both browser and the server.

So why write [Confidential][]?

The short answer is that auditability matters both in the implementation _and use_ of cryptographic functions. While TweetNaCl goes a long way toward making cryptography easier to use—and represents a huge step forward from libraries like OpenSSL—it remains too low-level for most application developers.

For example, encrypting an object typically requires that you:

- Decode the key and the object into byte arrays
- Generate a random nonce of the correct length
- Perform the encryption using NaCl's `secretbox` function
- Create a new byte array of the correct length
- Add the nonce and the ciphertext into the byte array
- Encode the byte array for use

Here's an example of how that might be implemented:

```coffeescript
prepare = (key, object) ->

  nonce = randomBytes secretbox.nonceLength
  message = decodeUTF8 JSON.stringify object
  box = secretbox message, nonce, decodeBase64 key

  envelope = new Uint8Array nonce.length + box.length
  envelope.set nonce
  envelope.set box, nonce.length

  encodeBase64 envelope
```

While this is relatively straightforward—and, remarkably, TweetNaCl includes robust type checking support—there are still a lot of ways to make a mistake. And it's _just_ complicated enough to discourage many application developers from implementing cryptographic features at all.

Contrast this with Confidential. This is the code to encrypt an object:

```coffeescript
prepare = (key, object) ->
  message = Message.from "utf-8", JSON.stringify object
  envelope = await encrypt message,  
              PrivateKey.from "base64", key
  envelope.to "base64"
```

Not only is the code simpler, it's also clearer. In fact, it's practically self-documenting. We prepare a message, encrypt it with a private key, and encode the resulting envelope as base64. All the inessential details have been encapsulated by types, like [`Message`][] and [`PrivateKey`][].

Crucially, all of the cryptographic operations are delegated to TweetNaCl. Confidential's only job is to present a more intuitive interface for using them, both in terms of writing the code and auditing it. Our hope is that this lowers the barriers for using state-of-the-art cryptography.
