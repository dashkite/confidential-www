Panda Confidential wraps the TweetNaCl.js cryptography library to provide a simple, sound interface for symmetric and asymmetric encryption, hashing, and digital signatures.

## Installation

For the browser, bundle using your favorite bundler:

```bash
npm i panda-confidential
```

## Usage

```coffeescript
import {confidential} from "panda-confidential"

# Instantiate an API
{encrypt, decrypt, sign, verify} = confidential()
```

## Learn More

- [Quick Start](./start)
- [API Reference](./api)
- [Introduction](./intro)
