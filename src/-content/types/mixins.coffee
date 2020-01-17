import {pipe, tee, rtee, curry} from "panda-garden"
import {cat, properties, titleCase} from "panda-parchment"
import {route as _route} from "../router"
import {glob} from "../indexer"

mix = (type, mixins) -> (pipe mixins...) type


indexer = curry rtee (f, T) ->
  (T.indexers ?= []).push f
  T::index ?= (indices) -> f.call @, indices for f in T.indexers

index = curry rtee (name, T) ->
  mix T, [
    indexer (indices) ->
      key = @[name]
      (indices[name] ?= {})[key] = @
  ]

basic = tee (T) ->
  T.create = (value) -> (new T).initialize value
  T::initialize = ({@source, @reference, @bindings}) -> @
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
    title: get: -> @data?.title ? titleCase @name
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
        if @template? then @template @ else @markdown

#
# PLAN
#
# Set up something akin to the ready handlers in Play
# (or the indexers here), but for initializing the object.
#
# The object we assemble from the YAML file may be “raw.”
# It may have async properties or contain wiki text.
#
# Initializers can resolve properties and process wiki text.
# These could be prefab so that you can simply define
# async properties, ex: `resolve "examples"`.
#
# This makes sense because we have more than one scenario
# where we need this, and because async properites may
# come up for other reasons than simply indexing. Otherwise,
# we might argue that we should make index-dependent operations
# sync and just hope it works out, and export a promised index
# for use when necessary (but that would also require that
# lookup/glob would need to take an optional second argument).
# But since this is also awkward for wiki text and any network
# operations would be inherently async, we can just go ahead
# and define initializers to take care of that.
#
# This way, the value ultimately in the index is easy to consume
# and we don't redundantly process wiki text.
#
# This also has the neat property of allowing any secondary indexing
# options to complete prior to initialization.
#
# To ensure the object is, in fact, ready for use, lookup/glob
# can include in their promise a check on the state of the object.
#

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
