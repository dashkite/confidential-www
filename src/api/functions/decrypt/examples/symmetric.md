##### Symmetric Decryption

```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{decrypt, Envelope} = confidential()
import {keyLookup, read} from "my-library"

do ->
  alice = keyLookup "Alice/private"

  serialized = read "greeting"
  envelope = Envelope.from "base64", serialized

  plaintext = await decrypt alice, envelope

  # You may format the plaintext with the instance method `to`.
  assert.equal (plaintext.to: "utf8"), "Hello, Alice!"
```
