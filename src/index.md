Panda Confidential wraps the [TweetNaCl.js][] cryptography library to provide a simple, sound interface for symmetric and asymmetric encryption, hashing, and digital signatures.

## Installation

Install Panda-Confidential with npm. Use your favorite bundler (Webpack, Rollup, …) to use it in the browser.

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

- [Quick Start][]
- [API Reference][API]
- [Guides][]
