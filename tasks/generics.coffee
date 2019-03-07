import {inspect} from "util"
import {Method} from "panda-generics"
import {isObject} from "panda-parchment"

truncate = (length, string) ->
  if string.length > length
    string[0..length] + "..."
  else
    string

invalidArguments = (name) ->
  (args...)->
    args = args
    .map (x) ->
      if !x? then "undefined" else truncate 120, inspect x
    .join ", "
    throw "#{name}: Invalid arguments: (#{args})"

method = (name) ->
  m = Method.create default: invalidArguments name
  m.define = (args...) -> Method.define m, args...
  m

has = (key) -> (value) -> (isObject value) && value[key]?

export {method, has}
