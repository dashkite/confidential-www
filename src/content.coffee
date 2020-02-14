import {curry} from "panda-garden"
import Store, {mix, store, route, content, data, loaders} from "@dashkite/hydrogen"
import {Block, Function, Method, Type} from "@dashkite/coda"
import Registry from "@dashkite/helium"
import links from "./-content/links.yaml"

# Tell WebPack to bundle what we need for our CMS
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

# Load helper to load bundled content
load = curry (extension, content) ->
  path = content.source.path
  try
    switch extension
      when "pug" then (require "./-content#{path}.pug")? content
      else require "./-content#{path}.#{extension}"

# Create CMS and register with the application namespace
Registry.add cms: cms = Store.create()

# Configure the content types:

# TODO allow the routes to be customized as well
#
# The reason we haven't done this already is because copying the interfaces
# requires us to parameterize a variety of different paths, not just the
# routes for loading them

Confidential =

  Block:
    mix class extends Block, [
      store cms
      route "{/path*}"
      content loaders [
        load "pug"
        load "md"
      ]
    ]

  Function:
    mix class extends Function, [
      store cms
      route "/api/functions/{name}"
      data load "yaml"
    ]

  Method:
    mix class extends Method, [
      store cms
      route "/api/types/{type}/{scope}/methods/{name}"
      route "/api/interfaces/{interface}/{scope}/methods/{name}"
      data load "yaml"
    ]

  Type:
    mix class extends Type, [
      store cms
      route "/api/types/{name}"
      data load "yaml"
      content loaders [
        load "md"
        load "pug"
      ]
    ]

# Tell CMS about the content

# TODO do we need to await on the addition of resources/links?

Store.load cms, context.keys()

# Add wikilinks to CMS

for key, link of links
  Store.add cms, index: "name", {key}, value: link
