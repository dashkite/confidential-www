import {first, last, rest, split, merge, include, toLower} from "panda-parchment"
import {match} from "./router"
import dictionary from "./links.yaml"
import "./types"

context = require.context "./", true, /\.(md|yaml|pug)$/
paths = context.keys()

join = (c, ax) -> ax.join c
drop = ([ax..., a]) -> ax

indices =
  name: dictionary

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

# TODO make this async via requestAnimationFrame?

for path in paths
  {source, reference} = parse path
  if (m = match reference.path)?
    {handler, bindings} = m
    data = merge {source, reference}, load source.path
    object = handler include data, bindings
    for index, key of object.index
      indices[index] ?= {}
      indices[index][key] = object

links = (html) ->
  html.replace /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, innerHTML, key) ->
    key ?= innerHTML.replace /<[^>]+>/g, ""
    if (target = lookup key)?
      "<a href='#{target.link ? target}'>#{innerHTML}</a>"
    else
      console.warn "Link [#{key}] not found."
      "<a href='#broken'>#{innerHTML}</a>"

export {lookup, links}
