Manages data format conversion between a variety of targets.

A conversion is specified by the fields of `hint`, `from` and `to`.  These identify the current and target format of `input`, respectively.

Typically, you will not need to use `convert` directly.  Panda-Confidential provides type classes (ex: [`Plaintext`](), [`Envelope`](), and [`Declaration`]()) with methods to manage data formatting.  Each class follows a convention to include the methods `from` and `to`, but internally, they all use `convert` to peform the conversion.

#### Supported Hints
- `bytes`: A byte array, specifically [`Uint8Array`]()
- `utf8`: A [`String`]() with [UTF-8 encoding]()
- `base64`: A [`String`]() with [Base64 encoding]()
- `safe-base64`: A [`String`]() with [URL-Safe Base64 encoding]()

#### Errors
`convert` is meant to provide safe and correct format conversion for your data.  There are a number of checks in place that will throw errors if they fail:
- Specifying an unsupported conversion
- Failing to specify either `from` or `to`
- Specifying the same value for `from` and `to`
- Specifying a value for `from` that conflicts with the type of `input`. ex, specifying `bytes` when the input is a string
