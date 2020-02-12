import {flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {router} from "../../helpers"
import {parent} from "../combinators"
import {property, view, activate, render, show} from "@dashkite/neon"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "/api/types/{name}",
  name: "view type"
  flow [
    property "path"
    parent
    # update title, meta tags, etc
    render "head", $head
    # update the breadcrumbs, nav
    render "header", $header
    # render the main block of the page as a page view
    view "main", $main
    # activate the function component,
    # which will load the content
    activate [ "site-type" ]
    # reveal the view
    show
  ]
