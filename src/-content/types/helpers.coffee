import {curry} from "panda-garden"

load = curry (extension, path) ->
  try
    require "../#{path[1..]}.#{extension}"

loaders = (fx) ->
  (args...) ->
    for f in fx
      if (result = f args...)?
        break
    result

export {load, loaders}
