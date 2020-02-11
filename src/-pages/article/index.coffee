import {flow} from "panda-garden"
import {add} from "@dashkite/oxgen"
import {router} from "../../helpers"
import {property, view, activate, render, show} from "@dashkite/neon"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"


add router, "{/parts*}",
  name: "view article"
  flow [
    property "data"
    property "path"
    view "main", $main
    render "head", $head
    render "header", $header
    activate [ "site-block" ]
    show
  ]
