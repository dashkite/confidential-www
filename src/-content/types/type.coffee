import {properties, all, isType, include, clone} from "panda-parchment"
import {mix, basic, summary, examples,
  route, index, data, ready} from "./mixins"
import {add, glob} from "../indexer"
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
                    copy = clone object
                    copy.reference.path = "#{@path}/#{scope}/#{category}/#{copy.name}"
                    copy.reference.parent = @path
                    add "path",
                      "#{@path}/#{scope}/#{category}/#{object.name}",
                      copy

class Type

  mix @, [
    basic, summary, examples
    route "/api/types/{name}"
    index "title"
    data load "yaml"
    ready aliases
  ]

  properties @::,
    title: get: -> @name
