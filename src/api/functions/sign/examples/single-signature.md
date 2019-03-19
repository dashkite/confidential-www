### Single Signature

Provide a [`Message`][] instance to the `data` argument and `sign` generates a new [`Declaration`][].

```coffeescript
import {confidential} from "panda-confidential"
{sign, Message} = confidential()

import {send, keyPairLookup} from "my-library"

do ->
  alice = keyPairLookup "Alice/signature"
  data = Message.from "utf8", "Hello, World!"

  declaration = sign alice, data

  # You may serialize with the instance method `to`
  send "Bob", declaration.to "base64"
```
