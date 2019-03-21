`SharedKey` encapsulates a key for use with [asymmetric encryption][]. A shared key is derived algorithmically from one [`PublicKey`][] (suitable for encryption) and one [`PrivateKey`][] (suitable for encryption).  That allows two entities to, independently, generate the same _shared_ secret key and conduct authenticated encryption/decryption.

> **Warning** A shared key is a secret, like a private key or password.
