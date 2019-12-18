import {properties, titleCase} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Block

  @create: (data) -> new Block data

  constructor: ({@source, @reference, @title}) ->
    @title ?= titleCase @name

  properties @::,
    name: get: -> @reference.name
    path: get: -> @reference.path
    link: get: -> "/" + @path
    index: get: ->
      title: @title
      path: @path
    template: get: ->
      try
        require "../#{@source.path}.pug"
    markdown: get: ->
      try
        require "../#{@source.path}.md"
    html: get: -> links if @template? then @template @ else @markdown


# catch-all for content that doesn't have a more specific type
route "{/path*}", Block.create
