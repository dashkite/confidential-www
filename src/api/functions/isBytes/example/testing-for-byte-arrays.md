```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{isBytes, Plaintext} = confidential()

do ->
  assert.equal (isBytes "Hello, World!"), false

  assert.equal (isBytes Buffer.from "Hello, World!"), true

  # Type classes can return byte arrays with the hint `bytes`
  plaintext = Plaintext.from "utf8", "Hello, World!"
  assert.equal (isBytes plaintext.to "bytes"), true
```
