import minimatch from "minimatch"
import {reduce} from "panda-river-esm"
import {first, last, rest, split,
  isString, keys, promise, all} from "panda-parchment"
import {match} from "./router"

# untility methods for parsing paths

join = (c, ax) -> ax.join c

drop = ([ax..., a]) -> ax

normalize = (components) ->
  name = first split ".", last components
  if components.length > 1
    parent = "/" + join "/", drop components
    path = join "/", [ parent, name ]
  else
    parent = "/"
    path = "/" + name
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

# private state shared between index functions
# TODO should this just be a class?
# presently, the index is effectively a singleton
_ =
  # raw indices, use only for updating
  $: {}

# promised indices, resolve after all the handlers are called
# use for access (find, lookup, glob)
_.indices = promise (resolve, reject) ->
  _.resolve = resolve
  _.reject = reject

# TODO support URLs
resources = (paths) ->
  # This appears to run in like 20 microseconds?
  # So I haven't bothered doing it via requestAnimationFrame
  # or in a worker thread or something like that
  for path in paths
    {source, reference} = parse path
    if (m = match reference.path)?
      {handler, bindings} = m
      handler {source, reference, bindings}
  # okay, make the index available for use
  _.resolve _.$

add = (index, key, value) -> (_.$[index] ?= {})[key] = value

# WARNING: race conditions may occur for defining and using an alias
alias = (index, from, to) ->
  if (value = (await _.indices)[index]?[from])?
    add index, to, value

lookup = (index, key) ->
  await (await _.indices)[index]?[key]

find = (key) ->
  for name, index of (await _.indices)
    return await value if (value = index[key])?
  # explicit return avoids implicit return of array of nulls
  undefined

glob = (pattern) ->
  dictionary = (await _.indices).path
  paths = minimatch.match (keys dictionary), pattern
  await all (dictionary[path] for path in paths)

# async replace
replace = (string, re, callback) ->
  do ({f, result} = {}, offset = 0) ->
    f = (string, result) ->
      do ({match, index, groups} = {}) ->
        {index} = result
        [match, groups...] = result
        replacement = await callback match, groups...
        start = index + offset
        finish = start + match.length
        offset += replacement.length - match.length
        "#{string[0...start]}\
         #{replacement}\
         #{string[finish...]}"
    # TODO reduce doesn't wait on the transform so we have to use a loop
    for result from string.matchAll re
      string = await f string, result
    string

links = (html) ->
  replace html, /\[([^\]]+)\]\[([^\]]+)?\]/g, (match, innerHTML, key) ->
    key ?= innerHTML.replace /<[^>]+>/g, ""
    if (target = await find key)?
      "<a href='#{target.link}'>#{innerHTML}</a>"
    else
      console.warn "Link [#{key}] not found."
      "<a href='#broken'>#{innerHTML}</a>"

export {resources, add, alias, lookup, find, glob, links}
