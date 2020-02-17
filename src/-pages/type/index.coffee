import {flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {property, view, activate, render, show} from "@dashkite/neon"
import {router} from "../../helpers"
import {parent, metadata} from "../combinators"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "/api/types/{name}",
  name: "view type"
  flow [
    parent
    metadata
    # update title, meta tags, etc
    render "head", $head
    # update the breadcrumbs, nav
    render "header", $header
    # render the main block of the page as a page view
    view "main", $main
    # activate the function component,
    # which will load the content
    activate [ "coda-type" ]
    # reveal the view
    show
  ]
