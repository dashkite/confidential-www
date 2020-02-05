import {mix, basic, data, title, content, route} from "@dashkite/hydrogen"
import {load, loaders} from "./helpers"

class Block
  mix @, [
    basic, title
    route "{/path*}"
    data load "yaml"
    content loaders [
      load "pug"
      load "md"
    ]
  ]
