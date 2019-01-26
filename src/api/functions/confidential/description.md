Instanciates the Panda-Confidential API.

Because Panda-Confidential is extensible, it uses instantiation to prevent unexpected changes by third parties. Once you have an instance, you can destructure its functions and types to use them directly.

`randomBytes` is an optional argument to replace the default [`randomBytes`]() implementation. Please use caution when replacing `randomBytes`.  Inadequate sources of psuedo-randomness compromise encryption.
