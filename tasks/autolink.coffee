import {identity} from "panda-garden"
import {isString, isObject, isArray} from "panda-parchment"
import {method, has} from "./generics"

isURL = (s) -> (isString s) && s.match /^((https?:\/\/)|\/)/

strip = (key) ->
  key
  .replace /[`_\*]/g, ""


# autolink lookups are normalized by converting to lowercase,
# removing any markdown formatting, and replacing any delimiters
# ex: `Declaration::to` => declaration/to

normalize = (key) ->
  key
  .toLowerCase()
  .replace /(\.|::)/, "/"

# link is the function that takes an object and adds a corresponding
# entry to the site's link dictionary
add = method "Autolink.add"

# the most general way to generate a link from an object is take its
# path and use that for the link...
add.define isObject, isString, isObject, (dictionary, key, entry) ->
  add dictionary, key, "/#{entry.path.join "/"}"

# we can override the use of the path by using a fragment, in which
# case we combine it with the parent path as such
add.define isObject, isString, (has "fragment"), (dictionary, key, entry) ->
  [ancestors..., _] = entry.path
  add dictionary, key, "/#{ancestors.join "/"}##{entry.fragment}"

# we can also override by simply providing a link directly
add.define isObject, isString, (has "link"),
  (dictionary, key, entry) -> add dictionary, key, entry.link

# converting the entry to a link will give us the key and the link,
# so this is where we add it to the dictionary
add.define isObject, isString, isString, (dictionary, key, link) ->
  dictionary[key] ?= link

# we can also just take an object and extract out the dictionary keys...
# we attempt to add links using both the key and the reference, so that
# you can use the key if its unambiguous, otherwise you need to qualify it
add.define isObject, isObject, (dictionary, entry) ->
  add dictionary, entry.key, entry
  add dictionary, entry.reference, entry

# autolink is what you call when you want to get a link corresponding
# to a value, either a string or an object
lookup = method "Autolink.lookup"

# if the object has a reference (all of are supposed to, see below),
# do the lookup using the reference. we don't need to normalize because
# references are already normalized. this is mostly useful for PugHelpers,
# ex when you have an object and want to do the lookup
lookup.define isObject, (has "reference"),
  (dictionary, {reference}) -> dictionary[reference]

# if we just get a string, normalize that and try the lookup. this is
# used within Pug (ex breadcrumbs) and also markdown, so we need to normalize
# the key before we do the lookup. if we don't find an entry, use #broken
lookup.define isObject, isString, (dictionary, key) ->
  key = strip key
  dictionary[key] ? dictionary[normalize key] ? do ->
    console.warn "Autolink.lookup: missing key [#{key}]"
    "#broken"

# in case we get a URL somehow ... this is useful if we want to use a Pug
# helper that calls autolink but we already have a URL
lookup.define isObject, isURL, (dictionary, url) -> url

Autolink = {add, lookup, normalize}

export default Autolink
