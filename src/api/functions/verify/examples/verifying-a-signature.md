```coffeescript
import {confidential} from "panda-confidential"
{verify, convert, Declaration} = confidential()
import {receive, process} from "my-library"

do ->
  # You may hydrate a Declaration instance with the static method `from`
  greeting = Declaration.from "base64", receive "Alice"

  if verify greeting
    # do something with the verified data.
    process convert from: "btyes", to: "utf8", greeting.data
  else
    throw new Error "Unable to verify data signatures."
```
