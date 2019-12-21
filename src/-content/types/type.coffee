import {properties} from "panda-parchment"
import {mix, basic, data, description, examples,
  index, indexer, route} from "./mixins"

class Type

  mix @, [
    basic, data, description, examples
    index "title"
    route "/api/types/{name}"
  ]

  properties @::,
    title: get: -> @name
