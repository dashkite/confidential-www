import {properties} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Type

  @create: (data) -> new Type data

  constructor: ({@source, @reference, @name, @extends, @interfaces}) ->

  properties @::,
    link: get: -> "/" + @reference.path
    index: get: ->
      name: @name
      path: @reference.path
    template: get: -> require "../#{@source.path}.pug"
    html: get: -> links @template @


route "api/types/{name}", Type.create
