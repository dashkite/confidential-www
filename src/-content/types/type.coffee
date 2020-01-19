import {properties} from "panda-parchment"
import {mix, basic, description, examples,
  route, index, data, ready} from "./mixins"
import {alias, glob} from "../indexer"
import {load} from "./helpers"

class Type

  mix @, [
    basic, description, examples
    route "/api/types/{name}"
    index "title"
    data load "yaml"
    ready ->
      for name in @data.interfaces
        @addInterface name
  ]

  properties @::,
    title: get: -> @name

  addInterface: (name) ->
    for scope in [ "class", "instance" ]
      for category in [ "methods", "properties" ]
        @addScopedInterface name, scope, category

  addScopedInterface: (name, scope, category) ->
    objects = await glob "/api/interfaces/#{name}/#{scope}/#{category}/*"
    for object in objects
      alias "path", object.path, "#{@path}/#{scope}/#{category}/#{object.name}"
