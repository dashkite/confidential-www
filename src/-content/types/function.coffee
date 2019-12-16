import {properties} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Function

  @create: (data) -> new Function data

  constructor: ({@source, @reference, @name}) ->

  properties @::,
    path: get: -> @reference.path
    link: get: -> "/#{@path}"
    index: get: -> {@name, @path}

route "/api/functions/{name}", Function.create
