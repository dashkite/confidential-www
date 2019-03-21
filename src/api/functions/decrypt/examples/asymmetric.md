##### Asymmetric Decryption

```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{SharedKey, decrypt, Envelope} = confidential()
import {keyLookup, receive} from "my-library"

do ->
  alice = keyLookup "Alice/public"
  bob = keyLookup "Bob/private"
  toBobFromAlice = SharedKey.create alice, bob

  serialized = receive "Bob"
  envelope = Envelope.from "base64", serialized

  plaintext = await decrypt toBobFromAlice, envelope

  # You may format the plaintext with the instance method `to`.
  assert.equal (plaintext.to: "utf8"), "Hello, Bob!"
```
