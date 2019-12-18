import {flow} from "panda-garden"
import {route} from "../../router"
import {add, view, activate, render, show} from "@dashkite/page-graph"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

route "/api/functions/{name}",

  name: "view function"

  flow [

    add "path"

    (context) ->
      context.bindings.parent =
        context.path
        .split "/"
        .slice(0,-1)
        .join "/"
      context

    # render the main block of the page as a page view
    view "main", $main

    # activate the function component,
    # which will load the content
    activate [ "site-function" ]

    # update title, meta tags, etc
    render "head", $head

    # update the breadcrumbs, nav
    render "header", $header

    # reveal the view
    show

  ]
