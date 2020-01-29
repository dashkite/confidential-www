import {flow} from "panda-garden"
import {route} from "../../router"
import {add, view, activate, render, show} from "@dashkite/page-graph"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

# TODO need combinator hide/show header?
route "/",
  name: "home"
  flow [
    add "path"
    view "main", $main
    render "head", $head
    render "header", $header
    activate [ "site-block" ]
    show
  ]
