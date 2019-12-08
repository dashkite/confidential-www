import dictionary from "./links.yaml"
context = require.context "./-content", true, /\.yaml/
paths = context.keys()

links = (html) ->
  html.replace /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, text, key) ->
    key ?= text
    if (link = dictionary[key])?
      "<a href='#{link}'>#{text}</a>"
    else
      if key[0] == ":"
        console.log data: _data
        match
      else
        console.warn "Link [#{key}] not found."
        "<a href='#broken'>#{text}</a>"

load = (path) ->
  data = require "./-content/#{path}/index.yaml"
  data.path = path
  data.html = links require "./-content/#{path}/index.md"
  data

initialize = ->
  root = {}
  index = {}
  for path in paths
    # the path (px) is between the . and the filename
    px = (path.split "/")[1..-2]
    # derive the data path (ps)
    ps = px.join "/"
    # load the data (pd)
    pd = load ps
    # split into everything up to the last (px) and the last (p)
    [pk..., p] = px
    # prepare to descend into the tree
    current = root
    for k in pk
      current = current[k] ?= {}
    # save into the tree
    current[p] = pd
    # save everything in the index
    # TODO we can also build up compound entries: api:functions:confidential
    index[p] = pd
  {root, index}

_data = initialize()
get = (key) ->
  _data.index[key]


export {load}
