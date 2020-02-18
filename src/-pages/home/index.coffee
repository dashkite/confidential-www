import {tee, flow} from "panda-garden"
import {add} from "@dashkite/oxygen"
import {router} from "../../helpers"

import {resource, properties,
  view, activate, render, show} from "@dashkite/neon"

import Store from "@dashkite/hydrogen"
import Registry from "@dashkite/helium"

import $head from "./head.pug"
import $header from "./header.pug"
import $main from "./index.pug"

add router, "/",
  name: "home"
  flow [
    resource (context) ->
      Store.get (Registry.get "cms"), index: "path", key: "/home"
    properties
      path: ({path}) -> path
      title: ({resource}) -> resource.title
      url: ({path}) -> window?.location.origin + path
      description: ({resource}) -> resource.summary
      image: -> window?.location.origin + "/logo.png"
    render "head", $head
    render "header", $header
    view "main", $main
    activate [ "hydrogen-block" ]
    show
  ]
