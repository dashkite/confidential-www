import {curry, tee, flow} from "panda-garden"
import {route} from "../../router"
import {hash, meta, root, page, view, activate, show} from "@dashkite/page-graph"
import render from "./index.pug"

path = curry (key, context) ->
  context.bindings[key] = context.bindings[key].join "/"

route "/",
  name: "home"
  -> console.log "hello"
  # flow [
  #   hash
  #   meta
  #   root "main"
  #   page
  #   view render
  #   activate [ "raven-article" ]
  #   show
  # ]

route "{/path*}",
  name: "view article"
  flow [
    page
    tee path "path"
    root "main"
    view render
    activate [ "raven-article" ]
    show
  ]
