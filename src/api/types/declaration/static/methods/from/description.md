`hint` informs `from` how convert `data` into `Declaration`'s internal reprentation.

#### Supported Hints
- `bytes`: A byte array, specifically [`Uint8Array`][]
- `utf8`: A [`String`][] with [UTF-8 encoding][]
- `base64`: A [`String`][] with [Base64 encoding][]
- `safe-base64`: A [`String`][] with [URL-Safe Base64 encoding][]

Specifying an unsupported conversion throws.

If `hint` conflicts with `data`'s type (ex: `data` is a byte array, while `hint` is "string"), `from` thows.
