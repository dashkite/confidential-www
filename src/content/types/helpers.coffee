import {curry} from "panda-garden"

load = curry (extension, content) ->
  path = content.source.path[1..]
  try
    switch extension
      when "pug" then (require "../../-content/#{path}.pug")? content
      else require "../../-content/#{path}.#{extension}"

loaders = (fx) ->
  (args...) ->
    for f in fx
      if (result = f args...)?
        break
    result

export {load, loaders}
