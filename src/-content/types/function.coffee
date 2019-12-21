import {properties} from "panda-parchment"
import {mix, basic, data, description, examples, index, route} from "./mixins"

class Function

  mix @, [
    basic, data, description, examples
    index "title"
    route "/api/functions/{name}"
  ]

  properties @::,
    title: get: -> @name
    signatures: get: -> @data.signatures
    variables: get: -> @data.variables
