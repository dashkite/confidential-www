import Path from "path"
import Autolink from "./autolink"

Site =

  data: {}

  clean: -> Site.data = {}

  # export autolinking
  autolink: (key) -> Autolink.lookup Site.data.links, key

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

  set: (path, entry) ->
    keys = Site.keys path
    [ancestors..., key] = keys
    parent = Site.traverse ancestors
    # an object can override the key, altho i'm unsure of a scenario
    # where that's necessary ...
    entry.key ?= key
    # overriding the name is probably more common, if the name doesn't
    # match the path for some reason. again, don't have a scenario for this,
    # but kept it just in case ...
    entry.name ?= key
    # parent object reference, which will be empty for things with no
    # explicitly defined parent (without a YAML file in the parent directory)
    entry.parent = parent
    # the logical path as an array of keys
    entry.path = keys
    # normalized reference, mainly useful for dictionary lookups
    entry.reference ?= Autolink.normalize "#{parent.key}/#{entry.key}"
    # save entry in the Site data
    parent[key] ?= entry
    # add entry to the dictionary
    Autolink.add Site.data.links, entry

export default Site
