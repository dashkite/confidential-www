import {flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {router} from "../../helpers"
import {view, activate, render, show} from "@dashkite/neon"
import {metadata} from "../combinators"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "{/parts*}",
  name: "view article"
  flow [
    metadata
    render "head", $head
    render "header", $header
    view "main", $main
    activate [ "hydrogen-block" ]
    show
  ]
