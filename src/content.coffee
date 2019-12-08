import {first, last, rest, split, merge} from "panda-parchment"
import dictionary from "./links.yaml"
context = require.context "./-content", true, /\.md/
paths = context.keys()

join = (c, ax) -> ax.join c
drop = ([ax..., a]) -> ax

links = (html) ->
  html.replace /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, text, key) ->
    key ?= text.replace /<[^>]+>/g, ""
    if (link = get key)?
      if link.reference?.path?
        link = "/" + link.reference.path
      "<a href='#{link}'>#{text}</a>"
    else
      console.warn "Link [#{key}] not found."
      "<a href='#broken'>#{text}</a>"

index =
  byName: dictionary
  byPath: {}

load = ({path}) ->
  try
    data = require "./-content/#{path}.yaml"
  catch
    data = {}
  data

normalize = (components) ->
  name = first split ".", last components
  parent = join "/", drop components
  path = join "/", [ parent, name ]
  {path, parent, name}

parse = (path) ->
  # ignore the initial .
  components = rest split "/", path
  source: normalize components
  reference: normalize drop components

get = (key) ->
  if (data = index.byName[key] ? index.byPath[key])?
    data

# TODO make this async via requestAnimationFrame?
# TODO index by title? index by qualified name (ex: KeyPair.isType)?

for path in paths
  {source, reference} = parse path
  data = merge {source, reference}, load source
  index.byPath[reference.path] = index.byName[reference.name] = data

for path, data of index.byPath
  try
    data.html ?= links require "./-content/#{data.source.path}.md"

export {get}
