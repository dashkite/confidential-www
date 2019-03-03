```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{hash, Plaintext} = confidential()

do ->
  # Instanciate a Plaintext with the input value
  plaintext = Plaintext.from "utf8", "Hello, World!"

  myHash = hash plaintext

  # You may serialize with the instance method `to`
  assert.equal (myHash.to "base64"),
    "N015SpXNz9izWZMYX++bo2jxYNja9DLQi6nx7R5avmzGkpHg+i/gAGpSVw7xjBne9OYXwzzlLvCm5fvjGMsDhw=="
```
