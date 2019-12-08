```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{hash, Message} = confidential()

do ->

  hashed = hash Message.from "utf8", "Hello, World!"

  assert.equal (hashed.to "base64"),
    "N015SpXNz9izWZMYX++bo2jxYNja9DLQi6nx7R5avmzGkpHg+i/gAGpSVw7xjBne9OYXwzzlLvCm5fvjGMsDhw=="
```
