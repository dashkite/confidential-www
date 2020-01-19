import {properties, all} from "panda-parchment"
import {mix, basic, description, examples,
  route, index, data, ready} from "./mixins"
import {alias, glob} from "../indexer"
import {load} from "./helpers"

# It's okay to wait on this initializer because it depends on the interfaces
# but the interfaces don't depend on types. Otherwise, we'd get a deadlock.
# So we can be sure the aliases are ready before use. We don't need explicit
# awaits (except for the glob) because we can do all the aliasing in parallel
# and the all will “roll up” the promises.
aliases = ->
  all do =>
    for name in @data.interfaces
      all do (name) =>
        for scope in [ "class", "instance" ]
          all do (scope) =>
            for category in [ "methods", "properties" ]
              do (category) =>
                path =  "/api/interfaces/#{name}/#{scope}/#{category}/*"
                objects = await glob path
                all do =>
                  for object in objects
                    # TODO since we already have the object we want to alias
                    #      should we add that to the alias interface?
                    alias "path", object.path,
                      "#{@path}/#{scope}/#{category}/#{object.name}"

class Type

  mix @, [
    basic, description, examples
    route "/api/types/{name}"
    index "title"
    data load "yaml"
    ready aliases
  ]

  properties @::,
    title: get: -> @name
