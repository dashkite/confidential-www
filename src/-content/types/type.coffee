import {properties} from "panda-parchment"
import {mix, basic, description, examples,
  route, index, data, ready} from "./mixins"
import {alias} from "../indexer"
import {load} from "./helpers"

class Type

  mix @, [
    basic, description, examples
    route "/api/types/{name}"
    index "title"
    data load "yaml"
    ready ->
      alias "path",
        "/api/interfaces/keypair/class/methods/create",
        "#{@path}/class/methods/create"
  ]

  properties @::,
    title: get: -> @name
