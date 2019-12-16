import {flow} from "panda-garden"
import {route} from "../../router"
import {view, activate, render, show} from "@dashkite/page-graph"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

route "/api/functions/{name}",

  name: "view function"

  flow [

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
