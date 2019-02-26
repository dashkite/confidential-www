import {inspect} from "util"
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
      if !x? then "undefined" else inspect x, colors: true
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

list = (dictionary) ->
  Object.keys dictionary
  .sort()
  .map (key) -> dictionary[key]
  .filter isObject

types = -> list Site.data.api.types
functions = -> list Site.data.api.functions

type = (key) -> Site.data.api.types[key]

schema = Method.create default: invalidArguments "schema"

Method.define schema, isString, isFunction,
  (key, filter) ->
    schema key
    .filter filter

Method.define schema, isObject,
  (type) ->
    list type
    .map (description) ->
      description.scope ?= "instance"
      description

Method.define schema, isString,
  (key) ->
    list type key
    .map (description) ->
      description.scope ?= "instance"
      description

# TODO add zero arg methods to generics
_properties = Method.create default: invalidArguments "properties"

Method.define _properties, isString, isString,
  (key, scope) ->
    schema key, (description) ->
      description.scope == scope && description.category == "property"

Method.define _properties, isString,
  (key) ->
    schema key, (description) ->
      description.category == "property"

properties = (args...) ->
  if args.length > 0
    _properties args...
  else
    list Site.data.api.properties

methods = Method.create default: invalidArguments "properties"

Method.define methods, isString, isString,
  (key, scope) ->
    schema key, (description) ->
      description.scope == scope && description.category == "method"

Method.define methods, isString,
  (key) ->
    schema key, (description) ->
      description.category == "method"

PugHelpers = {autolink, types, type, functions, schema, properties, methods}

export default PugHelpers
