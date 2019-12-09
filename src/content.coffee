import {first, last, rest, split, merge, toLower} from "panda-parchment"
import dictionary from "./links.yaml"
context = require.context "./-content", true, /\.(md|yaml|pug)$/
paths = context.keys()

join = (c, ax) -> ax.join c
drop = ([ax..., a]) -> ax

links = (html) ->
  html.replace /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, innerHTML, key) ->
    key ?= innerHTML.replace /<[^>]+>/g, ""
    if (link = get key)?
      if link.reference?.path?
        link = "/" + link.reference.path
      "<a href='#{link}'>#{innerHTML}</a>"
    else
      console.warn "Link [#{key}] not found."
      "<a href='#broken'>#{innerHTML}</a>"

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

get = (key) ->
  if (data = index.byName[key] ? index.byName[toLower key] ? index.byPath[key])?
    data

# TODO make this async via requestAnimationFrame?
# TODO index by title? index by qualified name (ex: KeyPair.isType)?

for path in paths
  {source, reference} = parse path
  if !index.byPath[reference.path]?
    data = load source
    data.source = source
    data.reference = reference
    try
      data.render = require "./-content/#{source.path}.pug"
    index.byPath[reference.path] = index.byName[reference.name] = data

for path, data of index.byPath
  try
    data.html ?= links require "./-content/#{data.source.path}.md"

export {get}
