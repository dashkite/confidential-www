import {flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {router} from "../../helpers"
import {property, view, activate, render, show} from "@dashkite/neon"
import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

# TODO we need to find a way to get all these variables defined:
  # title: "Hello, World"
  # url: "https://confidential.dashkite.com/foo/bar"
  # description: "This is a test description"
  # image: "https://confidential.dashkite.com/logo.png"


add router, "{/parts*}",
  name: "view article"
  flow [
    property "data"
    property "path"
    render "head", $head
    render "header", $header
    view "main", $main
    activate [ "site-block" ]
    show
  ]
