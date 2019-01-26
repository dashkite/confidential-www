Converts this instance's value into the form specified by `hint`.

`Hash` is a simple wrapper for the given hash, so `to` returns the hash itself, in whichever format you request.

#### Supported Hints
- `bytes`: A byte array, specifically [`Uint8Array`]()
- `utf8`: A [`String`]() with [UTF-8 encoding]()
- `base64`: A [`String`]() with [Base64 encoding]()
- `safe-base64`: A [`String`]() with [URL-Safe Base64 encoding]()

Specifying an unsupported conversion throws.
