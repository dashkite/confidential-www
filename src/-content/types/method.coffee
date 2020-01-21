import {properties} from "panda-parchment"
import {mix, basic, data, summary, examples, index, route} from "./mixins"
import {load} from "./helpers"

class Method

  mix @, [
    basic, summary
    route "/api/types/{type}/{scope}/methods/{name}"
    route "/api/interfaces/{interface}/{scope}/methods/{name}"
    data load "yaml"
    index "title"
  ]

  properties @::,
    title: get: -> @name
    signatures: get: -> @data.signatures
    variables: get: -> @data.variables
