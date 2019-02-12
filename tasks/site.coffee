import Path from "path"
import {camelCase} from "panda-parchment"

decorate = (key, value) ->
  value.name ?= camelCase key
  value.key ?= key
  value

Site =

  data: {}

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
    (Site.traverse keys)[key] = decorate key, value

export default Site
