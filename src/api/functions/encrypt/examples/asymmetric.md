##### Asymmetric Encryption

**Warning:** Private keys should only be accessible to their owners.

```coffeescript
import {confidential} from "panda-confidential"
{SharedKey, encrypt, Plaintext} = confidential()
import {keyLookup, send} from "my-library"

do ->
  alice = keyLookup "Alice/private"
  bob = keyLookup "Bob/public"
  fromAliceToBob = sharedKey.create alice, bob

  plaintext = Plaintext.from "utf8", "Hello, Bob!"

  envelope = await encrypt fromAliceToBob, plaintext

  # You may serialize with the instance method `to`
  send "Bob", envelope.to "base64"
```
