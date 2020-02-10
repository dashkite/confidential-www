import {curry} from "panda-garden"
import {create, store, content, data, loaders} from "@dashkite/hydrogen"
import {Function, Method, Type} from "@dashkite/hydrogen-docs"
import {register} from "@dashkite/helium"
import links from "./-content/links.yaml"

register cms: cms = create()

load = curry (extension, content) ->
  path = content.source.path[1..]
  try
    switch extension
      when "pug" then (require "./-content/#{path}.pug")? content
      else require "./-content/#{path}.#{extension}"

# TODO allow the routes to be customized as well
#
# The reason we haven't done this already is because copying the interfaces
# requires us to parameterize a variety of different paths, not just the
# routes for loading them

Confidential =

  Block:
    class extends Block
      store cms
      content loaders [
        load "pug"
        load "md"
      ]

  Function:
    class extends Function
      store cms
      data load "yaml"

  Method:
    class extends Method
      store cms
      data load "yaml"

  Type:
    class extends Type
      store cms
      data load "yaml"
      loaders [
        load "md"
        load "pug"
      ]

context = require.context "./-content", true,
  ///
    ^(                         # start followed by:
      (\/(?!\-))               # a / followed by anything other than a -
      |                        # or ...
      [^\/]                    # anything that isn't a /
    )+                         # repeat one or more times
    \.(md|yaml|pug)            # until extension of md, yaml, or pug
    $                          # and end
  ///

# TODO do we need to await on the addition of resources/links?

resources cms, context.keys()

for key, link of links
  add cms, index: "name", {key}, value: link
