```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{convert} = confidential()

do ->
  assert.equal "Hello, World!",
    convert from: "base64", to: "utf8", "SGVsbG8sIFdvcmxkIQ=="

  assert.equal (Buffer.from "Hello, World!"),
    convert from: "utf8", to: "bytes" , "Hello, World!"

  assert.equal "Hello, World!",
    convert from: "bytes", to: "utf8", Buffer.from "Hello, World!"
```
