The key type used to perform [symmetric encryption]().

> **Warning:** This key must remain secret for encryption be effective.

`SharedKey` extends [`Key`](), so it inherits its inteface: (Please see that class for more details.)
- `to`: instance method to return formatted internal data. `to` returns the key itself, in whichever format you request.
- `isKind`: static method providing a boolean prototype chain check for `Key`

`SharedKey` extends that interface with:
- `create`: static method to generate an instance of `SymmetricKey` suitable for [symmetric encryption]()
- `from`: static method to hydrate an instance of `SymmetricKey` from data
- `isType`: static method providing a boolean type-check for `SymmetricKey`
