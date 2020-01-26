import {flow} from "panda-garden"
import {route} from "../../router"
import {add, view, activate, render, show} from "@dashkite/page-graph"
import {parent} from "../combinators"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

route "/api/types/{name}",

  name: "view type"

  flow [

    add "path"
    parent

    # render the main block of the page as a page view
    view "main", $main

    # activate the function component,
    # which will load the content
    activate [ "site-type" ]

    # update title, meta tags, etc
    render "head", $head

    # update the breadcrumbs, nav
    render "header", $header

    # reveal the view
    show

  ]
