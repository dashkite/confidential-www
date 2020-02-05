import {properties, include, clone, isType, isFunction} from "panda-parchment"
import {mix, basic, data, summary, examples, index, route} from "@dashkite/hydrogen"
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
    category: get: -> @data.category
    scope: get: -> @data.scope
    signatures: get: -> @data.signatures
    variables: get: -> @data.variables

clone._.define (isType Method), ({source, reference, bindings}) ->
  include new Method, clone {source, reference, bindings}
