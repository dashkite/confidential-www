# Quick Start

Install Panda-Confidential with npm. Use your favorite bundler (Webpack, Rollup, …) to use it in the browser.

```shell
$ npm i panda-confidential
```

In your code, import the [`confidential`][] function. Invoking the function gives you access to the library. (Instantiating Confidential within a function helps prevent unexpected changes by third parties.) Grab the parts you want to use and go!

```coffeescript
import {confidential} from "panda-confidential"
{encrypt, SharedKey, Message} = confidential()

encryptMessage = (sender, reciever, message) ->

  key = SharedKey.create sender.privateKey,
    recipient.publicKey

  plaintext = Message.from "utf8", message
  envelope = await encrypt key, plaintext

  envelope.to "base64"
```

Confidential wraps the prescriptive [TweetNaCl.js][] library with pairs of opposing functions: [`encrypt`][] and [`decrypt`][], and [`sign`][] and [`verify`][]. These are _[generic functions][generic function]_, allowing Confidential to just do the right thing based on the arguments you pass.
