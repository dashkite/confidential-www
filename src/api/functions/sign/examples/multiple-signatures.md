### Multiple Signatures

`sign` supports multiple signatories.  Provide a [`Declaration`][] instance to the `data` argument and `sign` appends the signature to the existing list.

```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{sign, Declaration} = confidential()
import {send, receive, keyPairLookup} from "my-library"

do ->
  # You may hydrate a Declaration instance with the static method `from`
  greeting = Declaration.from "base64", receive "Bob"

  # add Bob's signature
  bob = keyPairLookup "Bob/signature"
  greeting = sign bob, greeting

  # sign appends to the lists signatures and signatories
  assert.equal greeting.signatures.length, 2
  assert.equal greeting.signatories.length, 2

  # You may serialize with the instance method `to`
  send "Charlotte", declaration.to "base64"
```
