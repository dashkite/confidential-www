import {properties} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Type

  @create: (data) -> new Type data

  constructor: ({@source, @reference}) ->

  properties @::,
    name: get: -> @reference.name
    title: get: -> @name
    path: get: -> @reference.path
    link: get: -> @path
    index: get: -> {@name, @path}
    data: get: ->
      try
        require "../#{@source.path[1..]}.yaml"


route "/api/types/{name}", Type.create
