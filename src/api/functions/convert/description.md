Behind the scenes, Confidential generics, like [`encrypt`][] operate on byte arrays. The purpose of `convert` is to make it easier to convert between byte arrays and other formats, like UTF-8 strings.

However, you will not typically need to use `convert` directly because Confidential also provides type classes, like [`Envelope`][], with `from` and `to` convenience methods that call `convert` for you.

A conversion is specified by the fields of `hint`, `from` and `to`. These identify the current and target format of `input`, respectively.

#### Supported Hints

- `bytes`: A byte array, specifically [`Uint8Array`][]
- `utf8`: A [`String`][] with [UTF-8 encoding][]
- `base64`: A [`String`][] with [Base64 encoding][]
- `safe-base64`: A [`String`][] with [URL-Safe Base64 encoding][]

#### Errors

`convert` is meant to provide safe and correct format conversion for your data.  There are a number of checks in place that will throw errors if they fail:
- Specifying an unsupported conversion
- Failing to specify either `from` or `to`
- Specifying the same value for `from` and `to`
- Specifying a value for `from` that conflicts with the type of `input`. ex, specifying `bytes` when the input is a string
