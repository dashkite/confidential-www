import {Method} from "panda-generics"
import {wrap, identity} from "panda-garden"
import {isDefined, isUndefined, isString, isObject, isFunction} from "panda-parchment"
import Site from "./site"

isURL = (s) -> (isString s) && s.match /^((https?:\/\/)|\/)/
isFragmentID = (s) -> (isString s) && s.match /^\#/
hasLink = (value) -> (isObject value) && value.link?
hasName = (value) -> (isObject value) && value.name?

invalidArguments = (name) ->
  (args...)->
    args = args
    .map (x) ->
      if !x? then "undefined" else JSON.stringify x, null, 2
    .join ", "
    throw "#{name}: Invalid arguments: (#{args})"

autolink = Method.create default: invalidArguments "autolink"

Method.define autolink, isURL, isString,
  (baseURL, path) -> "#{baseURL}/#{path}"

Method.define autolink, isURL, isFragmentID,
  (url, id) -> "#{url}##{id}"

Method.define autolink, hasLink, isDefined,
  (parent, child) -> autolink parent.link, child

Method.define autolink, hasName, isDefined,
  (parent, child) -> autolink (autolink parent.name), child

Method.define autolink, isString,
  (key) -> Site.data.links[key] ? Site.data.links["`#{key}`"]

Method.define autolink, isURL, identity

Method.define autolink, hasLink, ({link}) -> link

Method.define autolink, hasName, ({name}) -> autolink name

Method.define autolink, isDefined, isUndefined, (x) -> autolink x

list = Method.create default: invalidArguments "list"

Method.define list, isObject, (dictionary) ->
    Object.keys dictionary
    .sort()
    .map (key) -> dictionary[key]
    .filter isObject

Method.define list, isObject, isFunction, (dictionary, filter) ->
  list dictionary
  .filter filter

types = -> list Site.data.api.types
type = (key) -> list Site.data.api.types[key]
functions = -> list Site.data.api.functions

properties = Method.create default: (args...) ->
  if args.length == 0
    # with no arguments, just return top-level properties
    # TODO add support for zero-arg entries
    list Site.data.api.properties
  else
    (invalidArguments "properties")(args...)

Method.define properties, isString, isString, (key, scope) ->
  list Site.data.api.types[key],
    (description) ->
      description.scope ?= "instance"
      description.scope == scope &&
        description.category == "property"

methods = (key, scope) ->
  list Site.data.api.types[key], (description) ->
    description.scope == scope && description.category == "method"

PugHelpers = {autolink, types, type, functions, properties, methods}

export default PugHelpers
