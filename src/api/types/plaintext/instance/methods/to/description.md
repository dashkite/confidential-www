Converts this instance's value into the form specified by `hint`.

`Plaintext` is a simple wrapper for the given plaintext, so `to` returns the plaintext itself, in whichever format you request.

#### Supported Hints
- `bytes`: A byte array, specifically [`Uint8Array`]()
- `utf8`: A [`String`]() with [UTF-8 encoding]()
- `base64`: A [`String`]() with [Base64 encoding]()
- `safe-base64`: A [`String`]() with [URL-Safe Base64 encoding]()

Specifying an unsupported conversion throws.
