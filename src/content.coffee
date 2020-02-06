import {curry} from "panda-garden"
import start from "@dashkite/hydrogen-docs"
import links from "./-content/links.yaml"

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

start
  resources: context.keys()
  links: links
  load: curry (extension, content) ->
    path = content.source.path[1..]
    try
      switch extension
        when "pug" then (require "./-content/#{path}.pug")? content
        else require "./-content/#{path}.#{extension}"
