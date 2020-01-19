import "./types"
import {resources, add} from "./indexer"
import _links from "./-links.yaml"

# basically, the following just filters out paths with
# files or directories that begin with a -
# equivalent to: glob [ "**/*.{md,yaml,pug}",  "!**/-*/**", "!**/-*" ]
# WHICH DOES NOT SEEM LIKE IT SHOULD BE THIS COMPLICATED?
context = require.context "./", true,
  ///
    ^(                         # start followed by:
      (\/(?!\-))               # a / followed by anything other than a -
      |                        # or ...
      [^\/]                    # anything that isn't a /
    )+                         # repeat one or more times
    \.(md|yaml|pug)            # until extension of md, yaml, or pug
    $                          # and end
  ///

resources context.keys()

for key, link of _links
  add "name", key, link
