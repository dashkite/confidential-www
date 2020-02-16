import {curry} from "panda-garden"
import {include, clone, isType, all} from "panda-parchment"
import Store, {mix, store, route, content, data, loaders, ready} from "@dashkite/hydrogen"
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

# It's okay to wait on this initializer because it depends on the interfaces
# but the interfaces don't depend on types. Otherwise, we'd get a deadlock.
# So we can be sure the aliases are ready before use. We don't need explicit
# awaits (except for the glob) because we can do all the aliasing in parallel
# and the all will “roll up” the promises.
aliases = ->
  all do =>
    for name in @data.interfaces
      all do (name) =>
        for scope in [ "class", "instance" ]
          all do (scope) =>
            for category in [ "methods", "properties" ]
              do (category) =>
                path =  "/api/interfaces/#{name}/#{scope}/#{category}/*"
                objects = await Store.glob @store, path
                all do =>
                  for object in objects
                    copy = clone object
                    copy.reference.path = "#{@path}/#{scope}/#{category}/#{copy.name}"
                    copy.reference.parent = @path
                    all [

                        Store.add @store,
                          index: "path"
                          key: "#{@path}/#{scope}/#{category}/#{copy.name}",
                          value: copy
                      ,

                        if category == "methods"
                          if scope == "class"
                            Store.add @store,
                              index: "name"
                              key: "#{@name}.#{copy.name}"
                              value: copy
                          else
                            Store.add @store,
                              index: "name"
                              key: "#{@name}::#{copy.name}"
                              value: copy

                      ]

# Configure the content types:

Confidential =

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
      ready aliases
    ]

  # needs to go last since the order of the routes matters
  Block:
    mix class extends Block, [
      store cms
      route "{/path*}"
      data load "yaml"
      content loaders [
        load "pug"
        load "md"
      ]
    ]

do (Method = Confidential.Method) ->
  clone._.define (isType Method), ({source, reference, bindings}) ->
    include new Method, clone {source, reference, bindings}

# Tell CMS about the content

# TODO do we need to await on the addition of resources/links?

Store.load cms, context.keys()

# Add wikilinks to CMS

for key, link of links
  Store.add cms, {index: "name", key, value: {link}}
