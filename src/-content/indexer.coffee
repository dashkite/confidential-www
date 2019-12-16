import minimatch from "minimatch"
import {first, last, rest, split, merge, include,
  toLower, isString, keys} from "panda-parchment"
import {match} from "./router"
import _links from "./links.yaml"
import "./types"

# basically, the following just filters out paths with
# files or directories that begin with a -
# equivalent to: glob [ "**/*.{md,yaml,pug}",  "!**/-*/**", "!**/-*" ]
# WHICH DOES NOT SEEM LIKE IT SHOULD BE THIS COMPLICATED?
context = require.context "./", true,
  ///
    ^(                         # start followed by:
      (\/(?!\-))               # a / followed by anything other than a -
      |                        # or ...
      [^\/]                    # anything that isn't a /
    )+                         # repeat one or more times
    \.(md|yaml|pug)            # until extension of md, yaml, or pug
    $                          # and end
  ///

paths = context.keys()

join = (c, ax) -> ax.join c
drop = ([ax..., a]) -> ax

indices = name: {}
for key, link of _links
  indices.name[key] = link

load = (path) ->
  try
    data = require "./#{path}.yaml"
  catch
    data = {}
  data

normalize = (components) ->
  name = first split ".", last components
  if components.length > 1
    parent = join "/", drop components
    path = join "/", [ parent, name ]
  else
    parent = "/"
    path = name
  {path, parent, name}

parse = (path) ->
  # ignore the initial .
  components = rest split "/", path
  source = normalize components
  if source.name == "index"
    reference = normalize drop components
  else
    reference = source
  {source, reference}

lookup = (key) ->
  for name, index of indices
    return data if (data = index[key])?
  # explicit return avoids implicit return of array of nulls
  undefined

links = (html) ->
  html.replace /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, innerHTML, key) ->
    key ?= innerHTML.replace /<[^>]+>/g, ""
    if (target = lookup key)?
      # can't use target.link ? target b/c String::link() is a thing
      "<a href='#{if isString target then target else target.link}'>
        #{innerHTML}
      </a>"
    else
      console.warn "Link [#{key}] not found."
      "<a href='#broken'>#{innerHTML}</a>"

glob = (pattern) ->
  minimatch.match (keys indices.path), pattern
  .map lookup

# This appears to run in like 20 microseconds?
# So I haven't bothered doing it via requestAnimationFrame
# or in a worker thread or something like that
for path in paths
  {source, reference} = parse path
  if (m = match reference.path)?
    {handler, bindings} = m
    data = merge {source, reference}, load source.path
    object = handler include data, bindings
    for index, key of object.index
      indices[index] ?= {}
      indices[index][key] = object

export {lookup, links, glob}
