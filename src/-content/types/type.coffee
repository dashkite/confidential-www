import {properties, cat, first} from "panda-parchment"
import {route} from "../router"
import {links, glob} from "../indexer"

class Type

  @create: (data) -> new Type data

  constructor: ({@source, @reference}) ->

  properties @::,
    name: get: -> @reference.name
    title: get: -> @name
    path: get: -> @reference.path
    link: get: -> @path
    index: get: -> {@name, @path}
    summary: get: -> @data.summary
    description: get: -> (first glob "#{@path}/description")?.html ? ""
    examples: get: ->
      cat (glob "#{@path}/examples/*"),
        glob "#{@path}/example/*"
    data: get: ->
      try
        require "../#{@source.path[1..]}.yaml"


route "/api/types/{name}", Type.create
