`json` is a convenience method for restoring a value that was originally encoded as JSON.

## Example

```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{Message} = confidential()

message = Message.from "utf-8",
  JSON.stringify greeting: "hello"
assert.equal "hello",
  message.json().greeting
```
