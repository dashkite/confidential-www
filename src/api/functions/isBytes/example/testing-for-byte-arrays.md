```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{isBytes, Message} = confidential()

do ->
  assert.equal (isBytes "Hello, World!"), false

  assert.equal (isBytes Buffer.from "Hello, World!"), true

  # to method will return a byte array with the hint `bytes`
  plaintext = Message.from "utf8", "Hello, World!"
  assert.equal (isBytes plaintext.to "bytes"), true
```
