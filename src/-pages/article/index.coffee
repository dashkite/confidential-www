import {flow} from "panda-garden"
import {route} from "../../router"
import {add, view, activate, show} from "@dashkite/page-graph"
import $main from "./index.pug"

# TODO need combinator hide/show header?
route "/",
  name: "home"
  flow [
    view "main", $main
    activate [ "raven-article" ]
    show
  ]

route "{/path*}",
  name: "view article"
  flow [
    add "path"
    view "main", $main
    activate [ "raven-article" ]
    show
  ]
