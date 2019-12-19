import {properties, titleCase} from "panda-parchment"
import {route} from "../router"
import {links} from "../indexer"

class Block

  @create: (data) -> new Block data

  constructor: ({@source, @reference}) ->

  properties @::,
    name: get: -> @reference.name
    title: get: -> @data?.title ? titleCase @name
    path: get: -> @reference.path
    link: get: -> @path
    index: get: ->
      name: @name
      title: @title
      path: @path
    data: get: ->
      try
        require "../#{@source.path[1..]}.yaml"
    template: get: ->
      try
        require "../#{@source.path[1..]}.pug"
    markdown: get: ->
      try
        require "../#{@source.path[1..]}.md"
    html: get: ->
      try
        links if @template? then @template @ else @markdown


# catch-all for content that doesn't have a more specific type
route "{/path*}", Block.create
