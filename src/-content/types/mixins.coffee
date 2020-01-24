import {pipe, tee, rtee, curry} from "panda-garden"
import {cat, properties, titleCase, promise, all} from "panda-parchment"
import {route as _route} from "../router"
import {add, glob} from "../indexer"

mix = (type, mixins) -> (pipe mixins...) type

warrant = ->
  _ = {}
  _.promise = promise (resolve, reject) ->
    _.resolve = resolve
    _.reject = reject
  _

initialize = (instance, initializers) ->
  _ = warrant()
  try
    if initializers?
      await all do ->
        for initializer in initializers
          initializer.call instance, _.promise
    _.resolve  instance
  catch error
    _.reject error
  instance

basic = tee (T) ->
  T.create = (value) -> (new T).initialize value
  T::initialize = ({@source, @reference, @bindings}) ->
    initialize @, T.initializers
  properties T::,
    name: get: -> @reference.name
    path: get: -> @reference.path
    link: get: -> @path
  mix T, [
    index "name"
    index "path"
  ]

ready = curry rtee (f, T) -> (T.initializers ?= []).push f

index = curry rtee (name, T) ->
  # self is a promise for this
  # don't accidentally return promise, otherwise we'll await on it
  mix T, [
    ready (self) -> add name, @[name], self ; undefined
  ]

title = tee (T) ->
  properties T::,
    title: get: -> @data?.title ? titleCase @name
  mix T, [ index "title" ]

data = curry rtee (load, T) ->
  properties T::,
    data: get: ->
      try
        load @source.path

content = curry rtee (load, T) ->
  properties T::,
    template: get: ->
      try
        load @source.path
    html: get: ->
      @template? @

summary = tee (T) ->
  properties T::,
    summary: get: -> @data.summary

examples = tee (T) ->
  properties T::,
    examples: get: ->
      cat (glob "#{@path}/examples/*"),
        glob "#{@path}/example/*"

route = curry rtee (template, T) -> _route template, T.create

export {mix, basic, ready, index, data,
  title, content, summary, examples, route}
