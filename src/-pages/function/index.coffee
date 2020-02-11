import {flow} from "panda-garden"
import {add} from "@dashkite/oxgen"
import {router} from "../../helpers"
import {property, view, activate, render, show} from "@dashkite/neon"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "/api/functions/{name}",
  name: "view function"
  flow [
    property "path"
    # update title, meta tags, etc
    render "head", $head
    # update the breadcrumbs, nav
    render "header", $header
    # render the main block of the page as a page view
    view "main", $main
    # activate the function component,
    # which will load the content
    activate [ "site-function" ]
    # reveal the view
    show

  ]
