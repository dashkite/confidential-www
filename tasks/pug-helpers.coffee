import {inspect} from "util"
import {Method} from "panda-generics"
import {wrap, identity} from "panda-garden"
import {isDefined, isUndefined, isString, isObject, isFunction} from "panda-parchment"
import Site from "./site"

isURL = (s) -> (isString s) && s.match /^((https?:\/\/)|\/)/
isFragmentID = (s) -> (isString s) && s.match /^\#/
has = (key) -> (value) -> (isObject value) && value[key]?

truncate = (length, string) ->
  if string.length > length
    string[0..length] + "..."
  else
    string

invalidArguments = (name) ->
  (args...)->
    args = args
    .map (x) ->
      if !x? then "undefined" else truncate 120, inspect x
    .join ", "
    throw "#{name}: Invalid arguments: (#{args})"

autolink = Method.create default: invalidArguments "autolink"

Method.define autolink, (has "name"), isDefined,
  (parent, child) -> autolink (autolink parent.name), child

Method.define autolink, (has "link"), isDefined,
  (parent, child) -> autolink parent.link, child

Method.define autolink, isURL, (has "key"),
  (url, {key}) -> autolink url, key

Method.define autolink, isURL, (has "fragment"),
  (url, {fragment}) -> autolink url, "##{fragment}"

Method.define autolink, isURL, isString,
  (baseURL, path) -> "#{baseURL}/#{path}"

Method.define autolink, isURL, isFragmentID,
  (url, id) -> "#{url}#{id}"

Method.define autolink, (has "name"), (object) ->
  (autolink object.name) ?
    (if object.parent? then autolink object.parent, object)

Method.define autolink, (has "link"), ({link}) -> link

Method.define autolink, isString,
  (key) -> Site.data.links[key] ? Site.data.links["`#{key}`"]

Method.define autolink, isURL, identity




# TODO add sort to river
list = (dictionary) ->
  Object.keys dictionary
  .filter (key) -> key != "parent"
  .sort()
  .map (key) -> dictionary[key]
  .filter isObject

types = -> list Site.data.api.types
functions = -> list Site.data.api.functions

type = (key) -> Site.data.api.types[key]

typeInterface = Method.create default: invalidArguments "typeInterface"

Method.define typeInterface, isString, isFunction,
  (key, filter) ->
    typeInterface key
    .filter filter

Method.define typeInterface, isObject,
  (type) ->
    list type
    .map (description) ->
      description.scope ?= "instance"
      description

Method.define typeInterface, isString,
  (key) ->
    list type key
    .map (description) ->
      description.scope ?= "instance"
      description

_properties = Method.create default: invalidArguments "properties"

Method.define _properties, isString, isString,
  (key, scope) ->
    typeInterface key, (description) ->
      description.scope == scope && description.category == "property"

Method.define _properties, isString,
  (key) ->
    typeInterface key, (description) ->
      description.category == "property"

# TODO add zero arg methods to generics
properties = (args...) ->
  if args.length > 0
    _properties args...
  else
    list Site.data.api.properties

methods = Method.create default: invalidArguments "properties"

Method.define methods, isString, isString,
  (key, scope) ->
    typeInterface key, (description) ->
      description.scope == scope && description.category == "method"

Method.define methods, isString,
  (key) ->
    typeInterface key, (description) ->
      description.category == "method"

PugHelpers = {autolink, types, type, functions,
  typeInterface, properties, methods}

export default PugHelpers
