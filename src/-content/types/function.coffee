import {properties, cat, first} from "panda-parchment"
import {route} from "../router"
import {links, glob} from "../indexer"

class Function

  @create: (data) -> new Function data

  constructor: ({@source, @reference, @summary,
    @signatures, @variables}) ->

  properties @::,
    name: get: -> @reference.name
    title: get: -> @name
    path: get: -> @reference.path
    link: get: -> "/#{@path}"
    index: get: -> {@name, @path}
    description: get: -> (first glob "#{@path}/description")?.html ? ""
    examples: get: ->
      cat (glob "#{@path}/examples/*"),
        glob "#{@path}/example/*"

route "/api/functions/{name}", Function.create
