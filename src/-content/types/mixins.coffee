import {pipe, tee, rtee, curry} from "panda-garden"
import {properties, titleCase} from "panda-parchment"
import {route as _route} from "../router"
import {links} from "../indexer"

mix = (type, mixins) -> (pipe mixins...) type

bind = (instance, fx) -> f.bind instance for f in fx

indexer = curry rtee (f, T) ->
  console.log indexer: T
  T::index ?= (indices) ->
    console.log this: @
    (pipe (bind @, T.indexers)...) indices
  (T.indexers ?= []).push tee f

index = curry rtee (name, T) ->
  mix T, [
    indexer (indices) ->
      key = @[name]
      (indices[name] ?= {})[key] = @
  ]

basic = tee (T) ->
  T.create = (value) -> (new T).initialize value
  T::initialize = ({@source, @reference}) ->
  properties T::,
    name: get: -> @reference.name
    path: get: -> @reference.path
    link: get: -> @path
  mix T, [
    index "name"
    index "path"
  ]

title = tee (T) ->
  properties T::,
    title: get: -> @data.title ? titleCase name
  mix T, [ index "title" ]

data = tee (T) ->
  properties T::,
    data: get: ->
      try
        require "../#{@source.path[1..]}.yaml"

content = tee (T) ->
  properties T::,
    template: get: ->
      try
        require "../#{@source.path[1..]}.pug"
    markdown: get: ->
      try
        require "../#{@source.path[1..]}.md"
    html: get: ->
      try
        links if @template? then @template @ else @markdown

description = tee (T) ->
  properties T::,
    summary: get: -> @data.summary
    description: get: -> @data.description

examples = tee (T) ->
  properties T::,
    examples: get: ->
      cat (glob "#{@path}/examples/*"),
        glob "#{@path}/example/*"


route = curry rtee (template, T) -> _route template, T.create

export {mix, indexer, index, basic, data,
  title, content, description, examples, route}
