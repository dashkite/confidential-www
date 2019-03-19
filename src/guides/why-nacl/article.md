# Why NaCl?

NaCl is a state-of-the-art cryptography library that:

- Improves on prior art (ex: OpenSSL) in terms of security, usability, and speed.

- Is prescriptive: the library's authors have made all the algorithmic decisions for you, which is helpful, since this is a thing you probably [shouldn't want to do](https://tonyarcieri.com/all-the-crypto-code-youve-ever-written-is-probably-broken).

- Has a provenance is both [well-known](https://nsf.gov/awardsearch/showAward?AWD_ID=1018836) and reassuring: one of its authors, Daniel J. Bernstein, developed [Curve25519][], which has since [become a de facto standard cryptographic elliptic curve](https://ianix.com/pub/curve25519-deployment.html), used in TLS (SSL), HTTP/3 (QUICK), iOS and Android operating systems, the Signal messaging app, and, of course, NaCl, among many other uses.

In addition, Bernstein has a long history of [advocating for open access to strong encryption](https://en.wikipedia.org/wiki/Bernstein_v._United_States), which is reassuring in light of [questions about other elliptic curves](https://www.schneier.com/blog/archives/2013/09/the_nsa_is_brea.html#c1675929). While this is [hardly a guarantee](https://twitter.com/bascule/status/874626482806575104), taken as a whole, NaCl is as good a bet as you could make without spending years studying advanced cryptography.

## Why TweetNaCl?

[TweetNaCl][] builds upon NaCl by implementing it concisely enough to be published via Twitter. This aids in auditability, or how easy (and therefore likely) the code is to verify. TweetNaCl accomplishes this without compromising on security, reliability, portability, or speed. [Per Bernstein, et al](https://tweetnacl.cr.yp.to/tweetnacl-20140917.pdf):

> TweetNaCl is not merely readable; we claim that it is auditable. TweetNaCl is short enough and simple enough to be audited against a mathematical description of the functionality… TweetNaCl makes it possible to comprehensively audit the complete cryptographic portion of the trusted code base of a computer system…
>
> TweetNaCl [enjoys] the same protections as NaCl against simple timing attacks, cache-timing attacks, etc. It has no branches depending on secret data, and it has no array indices depending on secret data. We do not want developers to be faced with a choice between TweetNaCl’s conciseness and NaCl’s security… TweetNaCl’s functions compute the same outputs as C NaCl: the libraries are compatible. We have checked all TweetNaCl functions against the NaCl test suite…
>
> TweetNaCl is fast enough for typical applications. TweetNaCl’s focus on code size means that TweetNaCl cannot provide optimal run-time performance; NaCl’s optimized assembly is often an order of magnitude faster. However, TweetNaCl is sufficiently fast for most cryptographic applications. Most applications can tolerate the 4.2 million cycles that OpenSSL uses on an Ivy Bridge CPU for RSA-2048 decryption, for example, so they can certainly tolerate the 2.5 million cycles that TweetNaCl uses for higher-security decryption (Curve25519). Note that, at a typical 2.5GHz CPU speed, this is 1000 decryptions per second per CPU core…

## Why TweetNaCl.js?

[TweetNaCl.js][] amply demonstrates the claims made by Bernstein, et al, regarding TweetNaCl. It self-evidently demonstrates its portability (the JavaScript code maps almost line-for-line with the C code and it runs across browsers and Node) and conciseness (weighing in at just 7KB compressed). And an [audit performed by Cure53](https://tweetnacl.js.org/audits/cure53.pdf) reasonably demonstrates its auditability:

> The overall outcome of this audit signals a particularly positive assessment for TweetNaCljs, as the testing team was unable to find any security problems in the library. It has to be noted that this is an exceptionally rare result of a source code audit for any project…

Eventually, Web Assembly will make it possible to [compile TweetNaCl directly in the browser](https://github.com/dchest/tweetnacl-js/issues/141). Until then, TweetNaCl.js remains an ideal foundation for state-of-the-art cryptography in Web applications.

## What About WebCrypto?

TweetNaCl is auditable, portable, and prescriptive, whereas the WebCrypto API is not. It's is implemented differently on different platforms, with separate implementations for each of the major browser platforms and Node. The API is not incorporated into the Node API and at least one implementation is merely a wrapper around OpenSSL. This makes it virtually impossible to audit.

Developers must have considerable cryptographic expertise to use the WebCrypto API effectively. For example, the [`encrypt` method](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/encrypt) requires the specification of an algorithm, which is exactly the kind of choice developers often get wrong, and that make implementing cryptographic features difficult.

TweetNaCl.js _will_ use the WebCrypto [`getRandomValues`](https://developer.mozilla.org/en-US/docs/Web/API/Crypto/getRandomValues) method if available as the basis for [`randomBytes`].

##### Comparison of WebCrypto and TweetNaCl

| Feature      | WebCrypto                                                    | TweetNaCl                                  |
| ------------ | ------------------------------------------------------------ | ------------------------------------------ |
| Portability  | No                                                           | Yes                                        |
| Auditability | No (multiple code-bases, wide variety of algorithms, key types, and so forth) | Yes                                        |
| Prescriptive | No (developers must have cryptographic expertise)            | Yes                                        |
| Native       | Yes - in browsers.                                           | No (but fast enough for most applications) |
| Trusted Code | Yes - in browsers.                                           | No (code must loaded over HTTPS)           |

The main advantage for using the Web Crypto API is that cryptographic primitives do not need to be loaded over the network. However, in practice that provides little assurance, since malicious code running in the browser is likely able to gain access to private keys or, failing that, replace them with new ones. In addition, [subresource integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) can help ensure that the code being loaded has not been modified. In any event, the only secure way to run Web applications is to embed them in native containers. Use of the Web Crypto API does not signficiantly change the threat model for applications running within a browser.