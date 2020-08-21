```coffeescript
import {confidential} from "panda-confidential"
{randomBytes} = confidential()

bytes = await randomBytes 32
```
