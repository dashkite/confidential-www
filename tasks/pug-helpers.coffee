import {isString, isObject, isFunction} from "panda-parchment"
import {method} from "./generics"
import Site from "./site"

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

typeInterface = method "typeInterface"

typeInterface.define isString, isFunction,
  (key, filter) ->
    typeInterface key
    .filter filter

typeInterface.define isObject,
  (type) ->
    list type
    .filter ({category}) -> category?
    .map (description) ->
      description.scope ?= "instance"
      description

typeInterface.define isString,
  (key) ->
    list type key
    .filter ({category}) -> category?
    .map (description) ->
      description.scope ?= "instance"
      description

_properties = method "properties"

_properties.define isString, isString,
  (key, scope) ->
    typeInterface key, (description) ->
      description.scope == scope && description.category == "property"

_properties.define isString,
  (key) ->
    typeInterface key, (description) ->
      description.category == "property"

# TODO add zero arg methods to generics
properties = (args...) ->
  if args.length > 0
    _properties args...
  else
    list Site.data.api.properties.variables

methods = method "methods"

methods.define isString, isString,
  (key, scope) ->
    typeInterface key, (description) ->
      description.scope == scope && description.category == "method"

methods.define isString,
  (key) ->
    typeInterface key, (description) ->
      description.category == "method"

PugHelpers = {types, type, functions, typeInterface, properties, methods}

export default PugHelpers
