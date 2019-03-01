import Path from "path"
import {include} from "panda-parchment"

Site =

  data: {}

  clean: -> Site.data = {}

  key: (name) ->
    extension = Path.extname name
    Path.basename name, extension

  keys: (path) ->
    [keys..., name] = path.split Path.sep
    key = Site.key name
    if key == "index" then keys else [ keys..., key ]

  traverse: (keys) ->
    data = Site.data
    for key in keys
      data = (data[key] ?= {})
    data

  get: (path) ->
    Site.traverse Site.keys path

  set: (path, value) ->
    keys = Site.keys path
    [ancestors..., key] = keys
    parent = Site.traverse ancestors
    entry = (parent[key] ?= {key, name: key,  parent})
    entry.link = "/#{keys.join '/'}"
    Site.data.links ?= {}
    Site.data.links[entry.name] = entry.link
    Site.data.links["`#{entry.name}`"] = entry.link
    include entry, value
    parent[key]

export default Site
