import {properties} from "panda-parchment"
import {mix, basic, data, summary, examples, index, route} from "./mixins"
import {load} from "./helpers"

class Function

  mix @, [
    basic, summary
    route "/api/functions/{name}"
    data load "yaml"
    index "title"
  ]

  properties @::,
    title: get: -> @name
    signatures: get: -> @data.signatures
    variables: get: -> @data.variables
