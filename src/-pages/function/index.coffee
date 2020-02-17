import {flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {router} from "../../helpers"
import {view, activate, render, show} from "@dashkite/neon"
import {metadata} from "../combinators"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "/api/functions/{name}",
  name: "view function"
  flow [
    # update title, meta tags, etc
    metadata
    render "head", $head
    # update the breadcrumbs, nav
    render "header", $header
    # render the main block of the page as a page view
    view "main", $main
    # activate the function component,
    # which will load the content
    activate [ "coda-function" ]
    # reveal the view
    show

  ]
