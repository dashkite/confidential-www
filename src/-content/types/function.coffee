import {properties} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Function

  @create: (data) -> new Function data

  constructor: ({@source, @reference, @name}) ->

  properties @::,
    link: get: -> "/" + @reference.path
    index: get: ->
      name: @name
      path: @reference.path
    template: get: -> require "../#{@source.path}.pug"
    html: get: -> links @template @

route "/api/functions/{name}", Function.create
