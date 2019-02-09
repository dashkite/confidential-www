Panda Confidential wraps the TweetNaCl.js cryptography library to provide a simple, sound interface for symmetric and asymmetric encryption, hashing, and digital signatures.

## Installation

For the browser, bundle using your favorite bundler:

```bash
npm i panda-confidential
```

## Usage

In your code, import the [`confidential`][] function. Invoking the function gives you access to the library. (Instantiating Confidential within a function helps prevent unexpected changes by third parties.) Grab the parts you want to use and go!

```coffeescript
import {confidential} from "panda-confidential"

{encrypt, decrypt, sign, verify} = confidential()
```

## Learn More

- [Quick Start](/docs/quick-start)
- [API Reference](/api)
- [Documentation](/docs)
