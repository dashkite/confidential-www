import {properties, all} from "panda-parchment"
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
      await all do =>
        for name in @data.interfaces
          @addInterface name
  ]

  properties @::,
    title: get: -> @name

  addInterface: (name) ->
    for scope in [ "class", "instance" ]
      await all do =>
        for category in [ "methods", "properties" ]
          @addScopedInterface name, scope, category

  addScopedInterface: (name, scope, category) ->
    objects = await glob "/api/interfaces/#{name}/#{scope}/#{category}/*"
    await all do =>
      for object in objects
        # TODO since we already have the object we want to alias
        #      should we add that to the alias interface?
        alias "path", object.path,
          "#{@path}/#{scope}/#{category}/#{object.name}"
