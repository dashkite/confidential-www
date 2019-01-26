The Panda-Confidential generics (ex: [`encrypt`](), [`decrypt`](), [`sign`](), and [`verify`]()) are purposefully agnostic to the content they process, be it text or binary media.  The API always operates on byte arrays, requiring you convert inputs into bytes and then dealing with byte array outputs.

Typically, you will not need to use `convert` directly.  Panda-Confidential provides type classes with formatting methods that use `convert` internally.

Here is an example that uses these classes. Please see those class references for more information.


```coffeescript
import assert from "assert"
import {confidential} from "panda-confidential"
{SharedKey, Plaintext, encrypt, Envelope, decrypt} = confidential()
import {keyLookup} from "my-library"
do ->
  # First, Alice creates a SharedKey for asymmetric encryption..
  alice = keyLookup "Alice/private"
  bob = keyLookup "Bob/public"
  fromAliceToBob = SharedKey.create alice, bob

  # Use the Plaintext static method to turn the message into a byte array
  plaintext = Plaintext.from "utf8", "Hello, Bob!"
  envelope = await encrypt fromAliceToBob, plaintext

  # Use the Envelope instance method `to` to serialize.
  send "Bob", envelope.to "base64"



  # Later, with Bob on the recieving end....
  alice = keyLookup "Alice/public"
  bob = keyLookup "Bob/private"
  toBobFromAlice = SharedKey.create alice, bob
  serialized = receive "Bob"

  # Use the Envelope static method `from` to hydrate a new Envelope
  envelope = Envelope.from "base64", serialized
  plaintext = await decrypt toBobFromAlice, envelope

  # Use Plaintext instance method `to` to encode the plaintext
  assert.equal (plaintext.to "utf8"), "Hello, Bob!"
```
