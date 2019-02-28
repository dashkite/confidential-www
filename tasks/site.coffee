import Path from "path"
import {include} from "panda-parchment"

Site =

  data: {}

  clean: -> Site.data = {}

  createEntry: (key, parent) ->
    {key, name: key,  parent}

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
    [keys..., key] = Site.keys path
    parent = Site.traverse keys
    parent[key] ?= Site.createEntry key, parent
    include parent[key], value
    parent[key]

export default Site
